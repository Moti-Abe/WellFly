// ignore_for_file: unused_field, unused_element, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../../../data/models/flight_shopping_model.dart';
import '../../controllers/flight_controller.dart';
import '../../widgets/flight_selection_widgets.dart';
import '../models/round_trip_models.dart';
import '../widgets/rt_flight_card.dart';
import 'rt_select_fare_page.dart';

/// Page 3: Select a return flight — same layout as departing but for the return leg.
class RtReturnFlightsPage extends StatefulWidget {
  final RoundTripSearchCriteria criteria;
  final RoundTripFlight departureFlight;

  const RtReturnFlightsPage({
    super.key,
    required this.criteria,
    required this.departureFlight,
  });

  @override
  State<RtReturnFlightsPage> createState() => _RtReturnFlightsPageState();
}



class _RtReturnFlightsPageState extends State<RtReturnFlightsPage> {
  late DateTime _selectedDate;
  late List<RoundTripFlight> _flights = [];
  late Map<DateTime, double> _datePrices = {};

  FlightSortOption _sortOption = FlightSortOption.recommended;
  String _stopFilter = 'Any';
  Set<String> _airlineFilter = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.criteria.returnDate;
  }

  void _loadFlights() {
    // Handled via Obx
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _loadFlights();
    });
  }

  String get _fromCode {
    final match = RegExp(r'\((\w+)').firstMatch(widget.criteria.to);
    return match?.group(1) ?? widget.criteria.to.split(' ').first;
  }

  String get _toCode {
    final match = RegExp(r'\((\w+)').firstMatch(widget.criteria.from);
    return match?.group(1) ?? widget.criteria.from.split(' ').first;
  }

  String get _fromCity => widget.criteria.to.split(' (').first;
  String get _toCity => widget.criteria.from.split(' (').first;

  int _parseDurationMinutes(String d) {
    final hMatch = RegExp(r'(\d+)h').firstMatch(d);
    final mMatch = RegExp(r'(\d+)m').firstMatch(d);
    return (int.tryParse(hMatch?.group(1) ?? '0') ?? 0) * 60 +
        (int.tryParse(mMatch?.group(1) ?? '0') ?? 0);
  }


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark ? const Color(0xFF0B0F1A) : colors.surface;
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            FlightSearchPill(
              routeTitle: '$_fromCode($_fromCity) - $_toCity($_toCode)  (Return)',
              dateAndTravelerInfo: '${DateFormat('MMM d').format(widget.criteria.departDate)} - ${DateFormat('MMM d').format(widget.criteria.returnDate)}  ·  ${widget.criteria.travelers} traveler${widget.criteria.travelers > 1 ? 's' : ''}',
              onBack: () => Navigator.pop(context),
            ),
            // Selected departure summary
            _buildDepartureSummary(context),
            DatePriceScroller(
              datePrices: _datePrices,
              selectedDate: _selectedDate,
              onDateSelected: _selectDate,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.flightOffers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value.isNotEmpty && controller.flightOffers.isEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }

                if (controller.flightOffers.isEmpty) {
                  return const FlightEmptyState();
                }

                return ListView(
                  padding: const EdgeInsets.only(bottom: 80),
                  children: [
                    if (controller.isLoading.value)
                      const LinearProgressIndicator(),
                    const FlightSectionHeader(title: 'Select a return flight'),
                    ...controller.flightOffers.map((offer) {
                      final flight = _mapOfferToFlight(offer);
                      return RtFlightCard(
                        flight: flight,
                        onSelect: () => _selectReturnFlight(flight),
                      );
                    }),
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

  RoundTripFlight _mapOfferToFlight(FlightOffer offer) {
    if (offer.itineraries.length < 2) {
      // Fallback if return itinerary isn't available in this offer
      return RoundTripFlight(
        id: offer.id,
        airline: offer.airline,
        flightNumber: 'N/A',
        fromCity: widget.criteria.to,
        toCity: widget.criteria.from,
        date: widget.criteria.returnDate,
        departTime: '00:00',
        arriveTime: '00:00',
        duration: 'N/A',
        stops: 'N/A',
        price: double.parse(offer.price.total),
        cabin: widget.criteria.cabinClass,
      );
    }

    // For return flights, we use the second itinerary (index 1)
    final itinerary = offer.itineraries[1];
    final firstSegment = itinerary.segments.first;
    final lastSegment = itinerary.segments.last;

    return RoundTripFlight(
      id: offer.id,
      airline: offer.airline.isNotEmpty ? offer.airline : firstSegment.carrierCode,
      flightNumber: firstSegment.number,
      fromCity: widget.criteria.to,
      toCity: widget.criteria.from,
      date: widget.criteria.returnDate,
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

  // ─── Departure summary banner ───
  Widget _buildDepartureSummary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final bgColor = isDark ? const Color(0xFF111624) : const Color(0xFFE3F2FD);
    final dep = widget.departureFlight;
    final formatter = NumberFormat.simpleCurrency(
      name: 'USD',
      decimalDigits: 0,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: bgColor,
      child: Row(
        children: [
          Icon(
            Icons.flight_takeoff,
            size: 18,
            color: isDark ? const Color(0xFF7FB5FF) : const Color(0xFF1565C0),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Departing: ${dep.departTime} – ${dep.arriveTime}  ·  ${dep.airline}  ·  ${formatter.format(dep.price)}',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              'Change',
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF7FB5FF)
                    : const Color(0xFF1565C0),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Sort & Filter Bottom Sheet ───
  void _showSortFilterSheet() {
    final controller = Get.find<FlightController>();
    showFlightSortFilterSheet(
      context: context,
      currentSort: _sortOption,
      currentStopFilter: _stopFilter,
      currentAirlineFilter: _airlineFilter,
      availableAirlines: controller.flightOffers.map((f) => f.airline).toSet().toList()..sort(),
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
  void _selectReturnFlight(RoundTripFlight flight) {
    final controller = Get.find<FlightController>();
    Get.showOverlay(
      asyncFunction: () => controller.selectOffer(flight.id),
      loadingWidget: const Center(child: CircularProgressIndicator()),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RtSelectFarePage(
          criteria: widget.criteria,
          departureFlight: widget.departureFlight,
          returnFlight: flight,
        ),
      ),
    );
  }
}
