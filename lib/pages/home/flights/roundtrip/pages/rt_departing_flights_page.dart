// ignore_for_file: unused_element, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../../../data/models/flight_shopping_model.dart';
import '../../controllers/flight_controller.dart';
import '../../widgets/flight_selection_widgets.dart';
import '../models/round_trip_models.dart';
import '../widgets/rt_flight_card.dart';
import 'rt_return_flights_page.dart';

/// Page 2: Recommended departing flights with date-price scroller & Sort/Filter.
class RtDepartingFlightsPage extends StatefulWidget {
  final RoundTripSearchCriteria criteria;

  const RtDepartingFlightsPage({super.key, required this.criteria});

  @override
  State<RtDepartingFlightsPage> createState() => _RtDepartingFlightsPageState();
}



class _RtDepartingFlightsPageState extends State<RtDepartingFlightsPage> {
  late DateTime _selectedDate;
  late Map<DateTime, double> _datePrices = {};

  FlightSortOption _sortOption = FlightSortOption.recommended;
  String _stopFilter = 'Any';
  Set<String> _airlineFilter = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.criteria.departDate;
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
    final match = RegExp(r'\((\w+)').firstMatch(widget.criteria.from);
    return match?.group(1) ?? widget.criteria.from.split(' ').first;
  }

  String get _toCode {
    final match = RegExp(r'\((\w+)').firstMatch(widget.criteria.to);
    return match?.group(1) ?? widget.criteria.to.split(' ').first;
  }

  String get _fromCity => widget.criteria.from.split(' (').first;

  String get _toCity => widget.criteria.to.split(' (').first;

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
              routeTitle: '$_fromCode($_fromCity) - $_toCity($_toCode)',
              dateAndTravelerInfo: '${DateFormat('MMM d').format(widget.criteria.departDate)} - ${DateFormat('MMM d').format(widget.criteria.returnDate)}  ·  ${widget.criteria.travelers} traveler${widget.criteria.travelers > 1 ? 's' : ''}',
              onBack: () => Navigator.pop(context),
            ),
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
                    const FlightWatchPricesCard(),
                    const FlightDisclaimer(),
                    const FlightSectionHeader(title: 'Select a departing flight'),
                    ...controller.flightOffers.map((offer) {
                      // Map API offer to RoundTripFlight for UI compatibility
                      final flight = _mapOfferToFlight(offer);
                      return RtFlightCard(
                        flight: flight,
                        onSelect: () => _selectDepartureFlight(flight),
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
    if (offer.itineraries.isEmpty) {
      return RoundTripFlight(
        id: offer.id,
        airline: offer.airline,
        flightNumber: 'N/A',
        fromCity: widget.criteria.from,
        toCity: widget.criteria.to,
        date: widget.criteria.departDate,
        departTime: '00:00',
        arriveTime: '00:00',
        duration: 'N/A',
        stops: 'N/A',
        price: double.parse(offer.price.total),
        cabin: widget.criteria.cabinClass,
      );
    }

    // For departing flights, we use the first itinerary
    final itinerary = offer.itineraries.first;
    final firstSegment = itinerary.segments.first;
    final lastSegment = itinerary.segments.last;

    return RoundTripFlight(
      id: offer.id,
      airline: offer.airline.isNotEmpty ? offer.airline : firstSegment.carrierCode,
      flightNumber: firstSegment.number,
      fromCity: widget.criteria.from,
      toCity: widget.criteria.to,
      date: widget.criteria.departDate,
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
        // Note: Sort/Filter logic should be applied to list, 
        // but currently RtDepartingFlightsPage uses controller.flightOffers directly.
        // For now, this just updates the FAB state.
      },
    );
  }
  // ─── Navigation ───
  void _selectDepartureFlight(RoundTripFlight flight) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RtReturnFlightsPage(
          criteria: widget.criteria,
          departureFlight: flight,
        ),
      ),
    );
  }
}
