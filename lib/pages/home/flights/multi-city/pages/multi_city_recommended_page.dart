import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../../../data/models/flight_shopping_model.dart';
import '../../controllers/flight_controller.dart';
import '../../widgets/flight_selection_widgets.dart';
import '../models.dart';
import 'multi_city_flight_details_page.dart';
import 'multi_city_review_fare_page.dart';
import '../widgets/multi_city_flight_card.dart';



class MultiCityRecommendedPage extends StatefulWidget {
  final MultiCitySelection selection;
  final int segmentIndex;

  const MultiCityRecommendedPage({
    super.key,
    required this.selection,
    required this.segmentIndex,
  });

  @override
  State<MultiCityRecommendedPage> createState() =>
      _MultiCityRecommendedPageState();
}

class _MultiCityRecommendedPageState extends State<MultiCityRecommendedPage> {
  // Sort & Filter state
  FlightSortOption _sortOption = FlightSortOption.recommended;
  String _stopFilter = 'Any';
  Set<String> _airlineFilter = {};
  late List<MultiCityFlight> _flights = [];

  /// Parse a duration string like "5h 30m" into total minutes.
  int _parseDurationMinutes(String d) {
    final hMatch = RegExp(r'(\d+)h').firstMatch(d);
    final mMatch = RegExp(r'(\d+)m').firstMatch(d);
    return (int.tryParse(hMatch?.group(1) ?? '0') ?? 0) * 60 +
        (int.tryParse(mMatch?.group(1) ?? '0') ?? 0);
  }

  /// Apply current sort & filter to a raw flight list.
  List<MultiCityFlight> _applyFilters(List<MultiCityFlight> raw) {
    var list = raw.where((f) {
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

    switch (_sortOption) {
      case FlightSortOption.recommended:
        break;
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
    final criteria = widget.selection.criteria;
    final controller = Get.find<FlightController>();

    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            FlightSearchPill(
              routeTitle: _buildRouteLine(criteria),
              dateAndTravelerInfo: '${DateFormat('MMM d').format(criteria.depart1)}-${DateFormat('MMM d').format(criteria.depart2)}'
                  '${criteria.hasThirdLeg ? '-${DateFormat('MMM d').format(criteria.depart3!)}' : ''}'
                  '  ·  ${criteria.travelers} traveler${criteria.travelers > 1 ? 's' : ''}',
              onBack: () => Navigator.pop(context),
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

                final filteredFlights = _applyFilters(_flights);

                if (filteredFlights.isEmpty) {
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
                    _buildPromoBanner(context),
                    const FlightDisclaimer(),
                    const FlightSectionHeader(title: 'Recommended flights'),
                    ...filteredFlights.map(
                      (flight) => MultiCityFlightCard(
                        flight: flight,
                        onSelect: () => _openReviewFare(context, flight),
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

  MultiCityFlight _mapOfferToFlight(FlightOffer offer) {
    // For Multi-city, the segmentIndex tells us which itinerary we are looking at.
    final itineraryIndex = widget.segmentIndex - 1;
    if (itineraryIndex >= offer.itineraries.length) {
       return MultiCityFlight(
         id: offer.id,
         airline: offer.airline,
         flightNumber: 'N/A',
         fromCity: _segmentFrom(widget.selection.criteria, widget.segmentIndex) ?? '',
         toCity: _segmentTo(widget.selection.criteria, widget.segmentIndex) ?? '',
         date: _segmentDate(widget.selection.criteria, widget.segmentIndex) ?? DateTime.now(),
         departTime: '00:00',
         arriveTime: '00:00',
         duration: 'N/A',
         stops: 'N/A',
         price: double.parse(offer.price.total),
         cabin: widget.selection.criteria.cabinClass,
       );
    }

    final itinerary = offer.itineraries[itineraryIndex];
    final firstSegment = itinerary.segments.first;
    final lastSegment = itinerary.segments.last;

    return MultiCityFlight(
      id: offer.id,
      airline: offer.airline.isNotEmpty ? offer.airline : firstSegment.carrierCode,
      flightNumber: firstSegment.number,
      fromCity: _segmentFrom(widget.selection.criteria, widget.segmentIndex) ?? '',
      toCity: _segmentTo(widget.selection.criteria, widget.segmentIndex) ?? '',
      date: _segmentDate(widget.selection.criteria, widget.segmentIndex) ?? DateTime.now(),
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
      cabin: widget.selection.criteria.cabinClass,
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

  // ──────────── Open Review Fare Page ────────────
  void _openReviewFare(BuildContext context, MultiCityFlight flight) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiCityReviewFarePage(
          flight: flight,
          onSelect: () => _handleSelect(context, flight),
        ),
      ),
    );
  }

  // ──────────── Flight Selection Logic ────────────
  void _handleSelect(BuildContext context, MultiCityFlight flight) {
    if (widget.segmentIndex == 1) {
      final nextSelection = widget.selection.copyWith(flight1: flight);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiCityRecommendedPage(
            selection: nextSelection,
            segmentIndex: 2,
          ),
        ),
      );
    } else if (widget.segmentIndex == 2 &&
        widget.selection.criteria.hasThirdLeg) {
      final nextSelection = widget.selection.copyWith(flight2: flight);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiCityRecommendedPage(
            selection: nextSelection,
            segmentIndex: 3,
          ),
        ),
      );
    } else if (widget.segmentIndex == 2) {
      final nextSelection = widget.selection.copyWith(flight2: flight);
      final controller = Get.find<FlightController>();
      Get.showOverlay(
        asyncFunction: () => controller.selectOffer(flight.id),
        loadingWidget: const Center(child: CircularProgressIndicator()),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MultiCityFlightDetailsPage(selection: nextSelection),
        ),
      );
    } else {
      final nextSelection = widget.selection.copyWith(flight3: flight);
      final controller = Get.find<FlightController>();
      Get.showOverlay(
        asyncFunction: () => controller.selectOffer(flight.id),
        loadingWidget: const Center(child: CircularProgressIndicator()),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MultiCityFlightDetailsPage(selection: nextSelection),
        ),
      );
    }
  }

  // ──────────── Promo Banner ────────────
  Widget _buildPromoBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Diamond icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A2340) : const Color(0xFFE8EAF6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.diamond_outlined,
              color: Color(0xFF1565C0),
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book a flight and get \$20 in OneKeyCash to use toward your next trip',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Receive within 48 hours, use within 30 days. See terms',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────── Helpers ────────────
  String _buildRouteLine(MultiCitySearchCriteria criteria) {
    String fmt(String city) {
      final codeMatch = RegExp(r'\((\w+)\)').firstMatch(city);
      final code = codeMatch != null
          ? codeMatch.group(1)!
          : city.split(' ').last;
      final name = city.split(' (').first;
      return '$code($name)';
    }

    final segments = [
      fmt(criteria.from1),
      fmt(criteria.to1),
      fmt(criteria.to2),
    ];
    if (criteria.hasThirdLeg) {
      segments.add(fmt(criteria.to3!));
    }
    return segments.join(' → ');
  }

  String? _segmentFrom(MultiCitySearchCriteria criteria, int segment) {
    switch (segment) {
      case 1:
        return criteria.from1;
      case 2:
        return criteria.from2;
      case 3:
        return criteria.from3;
      default:
        return null;
    }
  }

  String? _segmentTo(MultiCitySearchCriteria criteria, int segment) {
    switch (segment) {
      case 1:
        return criteria.to1;
      case 2:
        return criteria.to2;
      case 3:
        return criteria.to3;
      default:
        return null;
    }
  }

  DateTime? _segmentDate(MultiCitySearchCriteria criteria, int segment) {
    switch (segment) {
      case 1:
        return criteria.depart1;
      case 2:
        return criteria.depart2;
      case 3:
        return criteria.depart3;
      default:
        return null;
    }
  }
}
