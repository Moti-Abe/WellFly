// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:expedia/pages/home/flights/OnewayPage/models/seat_model.dart';
import '../../../../data/services/api_service.dart';
import '../../../../data/models/flight_shopping_model.dart';
import '../../../../data/models/booking_model.dart';
import '../../../../data/models/airport_model.dart';
import '../../../../data/services/airport_service.dart';
import '../OnewayPage/models/one_way_models.dart';
import '../roundtrip/models/round_trip_models.dart';

class FlightController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final AirportSearchService airportService = Get.find<AirportSearchService>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Search Results
  var flightOffers = <FlightOffer>[].obs;
  
  // Selected Offer and Booking
  var selectedDepartureOffer = Rxn<FlightOffer>();
  var selectedReturnOffer = Rxn<FlightOffer>();
  var bookingLocator = ''.obs;
  var paymentOptions = <PaymentOption>[].obs;

  // Airport Search Results
  var searchResultsAirports = <AirportModel>[].obs;
  var isSearchingAirports = false.obs;

  // Search Query for Debouncing
  var currentSearchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Debounce the search query by 500ms to avoid rapid updates while typing
    debounce(currentSearchQuery, (String query) {
      if (query.isEmpty) {
        searchResultsAirports.assignAll([]);
        isSearchingAirports.value = false;
        return;
      }
      if (query.length >= 3) {
        _performSearch(query);
      } else {
        searchResultsAirports.assignAll([]);
        isSearchingAirports.value = false;
      }
    }, time: const Duration(milliseconds: 500));
  }

  void searchAirports(String query) {
    if (query.isEmpty) {
      searchResultsAirports.assignAll([]);
      isSearchingAirports.value = false;
    } else {
      isSearchingAirports.value = true;
      currentSearchQuery.value = query;
    }
  }

  void _performSearch(String query) {
    final results = airportService.searchAirports(query);
    searchResultsAirports.assignAll(results);
    isSearchingAirports.value = false;
  }

  // Detailed Offer (Fares, FQ, etc)
  var currentOfferPriceDetail = Rxn<Map<String, dynamic>>();

  double get currentBasePrice {
    final detail = currentOfferPriceDetail.value;
    return double.tryParse(detail?['data']?['flightOffers']?[0]?['price']?['base'] ?? '0') ?? 0;
  }

  double get currentTotalTax {
    final detail = currentOfferPriceDetail.value;
    final total = double.tryParse(detail?['data']?['flightOffers']?[0]?['price']?['total'] ?? '0') ?? 0;
    final base = double.tryParse(detail?['data']?['flightOffers']?[0]?['price']?['base'] ?? '0') ?? 0;
    return total - base;
  }

  double get currentGrandTotal {
    final detail = currentOfferPriceDetail.value;
    return double.tryParse(detail?['data']?['flightOffers']?[0]?['price']?['total'] ?? '0') ?? 0;
  }

  Future<void> searchFlights(FlightShoppingRequest request) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      print('=== FLIGHT SEARCH REQUEST PAYLOAD ===');
      print(request.toJson());
      print('=====================================');

      final response = await _apiService.searchFlights(request);
      if (response != null) {
        flightOffers.value = response.offers;
      } else {
        errorMessage.value = 'Failed to fetch flights. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Deprecated: searchCities(String query) async { ... } from API is replaced by searchAirports.

  Future<void> selectOffer(String offerId) async {
    try {
      isLoading.value = true;
      currentOfferPriceDetail.value = null; // Reset
      final response = await _apiService.getOfferPrice(offerId);
      if (response != null) {
        currentOfferPriceDetail.value = response;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load offer details: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Mapping API JSON to UI Models ───

  List<FareOption> getFaresFromApi() {
    final detail = currentOfferPriceDetail.value;
    if (detail == null) return [];
    
    // In a real API, we parse travelerPricings -> fareDetailsBySegment
    // For now, we'll create a few standard options derived from the API price
    // to ensure the UI remains fully driven by the controller's state.
    // Attempt to get the branded fare from the first traveler/segment
    final brandedFare = detail['data']?['flightOffers']?[0]?['travelerPricings']?[0]?['fareDetailsBySegment']?[0]?['brandedFare'] ?? 'Standard Economy';
    final cabin = detail['data']?['flightOffers']?[0]?['travelerPricings']?[0]?['fareDetailsBySegment']?[0]?['cabin'] ?? 'Economy';
    
    // In a real scenarios, various offers might be returned. 
    // We display the main one and a flexible alternative derived from the API data.
    return [
      FareOption(
        name: brandedFare,
        description: 'Class: $cabin',
        priceMultiplier: 1.0,
        features: [
          const FareFeature(text: 'Personal item included', type: FareFeatureType.included),
          const FareFeature(text: 'Carry-on bag included', type: FareFeatureType.included),
          const FareFeature(text: 'Standard seat assigned', type: FareFeatureType.included),
        ],
      ),
      FareOption(
        name: 'Flex $cabin',
        description: 'Flexible options for $brandedFare',
        priceMultiplier: 1.25,
        features: [
          const FareFeature(text: 'Personal item included', type: FareFeatureType.included),
          const FareFeature(text: 'Refundable to voucher', type: FareFeatureType.included),
          const FareFeature(text: 'Changes allowed', type: FareFeatureType.included),
        ],
      ),
    ];
  }

  List<List<SeatInfo>> getSeatMapFromApi() {
    // Ideally this comes from a dedicated seatmap API or offer-price ancillaries
    // Returning a default structured map for now that is managed by the controller.
    final rows = <List<SeatInfo>>[];
    final cols = ['A', 'B', 'C', '', 'D', 'E', 'F'];
    for (int row = 1; row <= 20; row++) {
      final seats = <SeatInfo>[];
      for (final col in cols) {
        if (col.isEmpty) {
          seats.add(const SeatInfo(label: '', type: SeatType.available));
          continue;
        }
        seats.add(SeatInfo(label: '$row$col', type: SeatType.available));
      }
      rows.add(seats);
    }
    return rows;
  }

  List<BaggageOption> getBaggageFromApi() {
    return [
      const BaggageOption(label: 'No checked bags', description: 'API Default', price: 0, bags: 0),
      const BaggageOption(label: '1 checked bag', description: 'Up to 23kg', price: 40, bags: 1),
    ];
  }

  // Similar for Round Trip
  List<RtFareOption> getRtFaresFromApi() {
    final detail = currentOfferPriceDetail.value;
    final brandedFare = detail?['data']?['flightOffers']?[0]?['travelerPricings']?[0]?['fareDetailsBySegment']?[0]?['brandedFare'] ?? 'Basic';
    final cabin = detail?['data']?['flightOffers']?[0]?['travelerPricings']?[0]?['fareDetailsBySegment']?[0]?['cabin'] ?? 'Economy';

    return [
      RtFareOption(
        name: brandedFare,
        description: 'Class: $cabin',
        priceMultiplier: 1.0,
        features: [
          const RtFareFeature(text: 'Personal item', type: RtFareFeatureType.included),
        ],
      ),
      RtFareOption(
        name: 'Standard $cabin',
        description: 'Most popular choice',
        priceMultiplier: 1.2,
        features: [
          const RtFareFeature(text: 'Carry-on included', type: RtFareFeatureType.included),
          const RtFareFeature(text: 'Seat choice paid', type: RtFareFeatureType.paid),
        ],
      ),
    ];
  }

  List<List<SeatInfo>> getRtSeatMapFromApi() {
    final rows = <List<SeatInfo>>[];
    final cols = ['A', 'B', 'C', '', 'D', 'E', 'F'];
    for (int row = 1; row <= 20; row++) {
      final seats = <SeatInfo>[];
      for (final col in cols) {
        if (col.isEmpty) {
          seats.add(const SeatInfo(label: '', type: SeatType.available));
          continue;
        }
        seats.add(SeatInfo(label: '$row$col', type: SeatType.available));
      }
      rows.add(seats);
    }
    return rows;
  }

  List<RtBaggageOption> getRtBaggageFromApi() {
    return [
      const RtBaggageOption(label: 'No checked bags', description: 'API Default', price: 0, bags: 0),
      const RtBaggageOption(label: '1 checked bag', description: 'Up to 23kg', price: 45, bags: 1),
    ];
  }

  Future<bool> startBooking(BookingHoldRequest request) async {
    try {
      isLoading.value = true;
      final response = await _apiService.holdBooking(request);
      if (response != null) {
        bookingLocator.value = response.bookingLocator;
        await fetchPaymentOptions();
        return true;
      }
    } catch (e) {
      errorMessage.value = 'Booking failed: $e';
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<void> fetchPaymentOptions() async {
    if (bookingLocator.isEmpty) return;
    paymentOptions.value = await _apiService.getPaymentOptions(bookingLocator.value);
  }

  Future<bool> confirmBooking(ConfirmBookingRequest request) async {
    try {
      isLoading.value = true;
      final response = await _apiService.confirmPayment(request);
      if (response != null) {
        // Handle success/callback
        return true;
      }
    } catch (e) {
      errorMessage.value = 'Payment failed: $e';
    } finally {
      isLoading.value = false;
    }
    return false;
  }
}
