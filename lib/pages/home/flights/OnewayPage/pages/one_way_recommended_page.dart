// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../../../data/models/flight_shopping_model.dart';
import '../../controllers/flight_controller.dart';
import '../../widgets/flight_selection_widgets.dart';
import '../models/one_way_models.dart';
import '../widgets/one_way_flight_card.dart';
import 'one_way_select_fare_page.dart';

/// Page 2: Recommended departing flights with horizontal date-price scroller.
class OneWayRecommendedPage extends StatefulWidget {
  final OneWaySearchCriteria criteria;

  const OneWayRecommendedPage({super.key, required this.criteria});

  @override
  State<OneWayRecommendedPage> createState() => _OneWayRecommendedPageState();
}

class _OneWayRecommendedPageState extends State<OneWayRecommendedPage> {
  late DateTime _selectedDate;
  late List<OneWayFlight> _flights = [];
  late Map<DateTime, double> _datePrices = {};

  // Sort & Filter state
  FlightSortOption _sortOption = FlightSortOption.recommended;
  String _stopFilter = 'Any'; // 'Any', 'Nonstop', '1 stop or fewer'
  Set<String> _airlineFilter = {}; // empty = all

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.criteria.departDate;
  }

  void _loadFlights() {
    // API data is handled via Obx in the build method
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _loadFlights();
    });
  }

  String get _fromCode {
    final match = RegExp(r'\((\w+)').firstMatch(widget.criteria.from);
    return match?.group(1) ?? widget.criteria.from.split(' ').first;
  }

  String get _toCode {
    final match = RegExp(r'\((\w+)').firstMatch(widget.criteria.to);
    return match?.group(1) ?? widget.criteria.to.split(' ').first;
  }

  String get _fromCity {
    return widget.criteria.from.split(' (').first;
  }

  String get _toCity {
    return widget.criteria.to.split(' (').first;
  }

  /// Returns a duration in minutes parsed from a string like "5h 30m".
  int _parseDurationMinutes(String d) {
    final hMatch = RegExp(r'(\d+)h').firstMatch(d);
    final mMatch = RegExp(r'(\d+)m').firstMatch(d);
    return (int.tryParse(hMatch?.group(1) ?? '0') ?? 0) * 60 +
        (int.tryParse(mMatch?.group(1) ?? '0') ?? 0);
  }

  /// Returns the list of flights after applying current sort & filter settings.
  List<OneWayFlight> get _displayFlights {
    // Filter
    var list = _flights.where((f) {
      if (_stopFilter == 'Nonstop' && f.stops != 'Nonstop') return false;
      if (_stopFilter == '1 stop or fewer' &&
          f.stops != 'Nonstop' &&
          f.stops != '1 stop') {
        return false;
      }
      if (_airlineFilter.isNotEmpty && !_airlineFilter.contains(f.airline)) {
        return false;
      }
      return true;
    }).toList();

    // Sort
    switch (_sortOption) {
      case FlightSortOption.recommended:
        break; // keep original order
      case FlightSortOption.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
      case FlightSortOption.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
      case FlightSortOption.durationShort:
        list.sort(
          (a, b) => _parseDurationMinutes(
            a.duration,
          ).compareTo(_parseDurationMinutes(b.duration)),
        );
      case FlightSortOption.departEarly:
        list.sort((a, b) => a.departTime.compareTo(b.departTime));
      case FlightSortOption.departLate:
        list.sort((a, b) => b.departTime.compareTo(a.departTime));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark ? const Color(0xFF0B0F1A) : colors.surface;
    final controller = Get.find<FlightController>();

    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            FlightSearchPill(
              routeTitle: '$_fromCode($_fromCity) - $_toCity($_toCode)',
              dateAndTravelerInfo: '${DateFormat('MMM d').format(_selectedDate)}  ·  ${widget.criteria.travelers} traveler${widget.criteria.travelers > 1 ? 's' : ''}',
              onBack: () => Navigator.pop(context),
            ),
            DatePriceScroller(
              datePrices: _datePrices,
              selectedDate: _selectedDate,
              onDateSelected: _selectDate,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }

                _flights = controller.flightOffers.map((offer) => _mapOfferToFlight(offer)).toList();

                if (_flights.isEmpty) {
                  return const FlightEmptyState();
                }

                final visible = _displayFlights;
                if (visible.isEmpty) {
                  return FlightNoFilterResults(
                    onClearFilters: () => setState(() {
                      _sortOption = FlightSortOption.recommended;
                      _stopFilter = 'Any';
                      _airlineFilter = {};
                    }),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.only(bottom: 80),
                  children: [
                    const FlightWatchPricesCard(),
                    const FlightDisclaimer(),
                    const FlightSectionHeader(title: 'Recommended departing flights'),
                    ...visible.map(
                      (flight) => OneWayFlightCard(
                        flight: flight,
                        onSelect: () => _openSelectFare(context, flight),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FlightSortFilterFab(
        hasActiveFilters: _sortOption != FlightSortOption.recommended ||
            _stopFilter != 'Any' ||
            _airlineFilter.isNotEmpty,
        onTap: _showSortFilterSheet,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  OneWayFlight _mapOfferToFlight(FlightOffer offer) {
    if (offer.itineraries.isEmpty) {
      return OneWayFlight(
        id: offer.id,
        airline: offer.airline,
        flightNumber: 'N/A',
        fromCity: widget.criteria.from,
        toCity: widget.criteria.to,
        date: _selectedDate,
        departTime: '00:00',
        arriveTime: '00:00',
        duration: 'N/A',
        stops: 'N/A',
        price: double.parse(offer.price.total),
        cabin: widget.criteria.cabinClass,
      );
    }

    final itinerary = offer.itineraries.first;
    final firstSegment = itinerary.segments.first;
    final lastSegment = itinerary.segments.last;
    
    return OneWayFlight(
      id: offer.id,
      airline: offer.airline.isNotEmpty ? offer.airline : firstSegment.carrierCode,
      flightNumber: firstSegment.number,
      fromCity: widget.criteria.from,
      toCity: widget.criteria.to,
      date: _selectedDate,
      departTime: firstSegment.departure.at.contains('T') 
          ? firstSegment.departure.at.split('T').last.substring(0, 5) 
          : firstSegment.departure.at,
      arriveTime: lastSegment.arrival.at.contains('T') 
          ? lastSegment.arrival.at.split('T').last.substring(0, 5) 
          : lastSegment.arrival.at,
      duration: itinerary.duration,
      stops: itinerary.segments.length > 1 
          ? '${itinerary.segments.length - 1} stop${itinerary.segments.length > 2 ? 's' : ''}' 
          : 'Nonstop',
      price: double.parse(offer.price.total),
      cabin: widget.criteria.cabinClass,
    );
  }





  // ──────────── Sort & Filter Bottom Sheet ────────────
  void _showSortFilterSheet() {
    showFlightSortFilterSheet(
      context: context,
      currentSort: _sortOption,
      currentStopFilter: _stopFilter,
      currentAirlineFilter: _airlineFilter,
      availableAirlines: _flights.map((f) => f.airline).toSet().toList()..sort(),
      onApply: (newSort, newStop, newAirlines) {
        setState(() {
          _sortOption = newSort;
          _stopFilter = newStop;
          _airlineFilter = newAirlines;
        });
      },
    );
  }

  // ─── Navigation ───
  void _openSelectFare(BuildContext context, OneWayFlight flight) {
    final controller = Get.find<FlightController>();
    Get.showOverlay(
      asyncFunction: () => controller.selectOffer(flight.id),
      loadingWidget: const Center(child: CircularProgressIndicator()),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OneWaySelectFarePage(flight: flight, criteria: widget.criteria),
      ),
    );
  }
}
