import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/flight_controller.dart';
import '../models/one_way_models.dart';
import 'package:expedia/pages/home/flights/OnewayPage/models/seat_model.dart';
import '../widgets/booking_app_bar.dart';
import '../widgets/booking_step_indicator.dart';
import '../widgets/booking_bottom_bar.dart';
import '../../widgets/shared_seat_map.dart';
import 'one_way_bags_page.dart';

/// Page 5: Seat selection with visual seat map.
class OneWaySeatSelectionPage extends StatefulWidget {
  final OneWayBooking booking;

  const OneWaySeatSelectionPage({super.key, required this.booking});

  @override
  State<OneWaySeatSelectionPage> createState() =>
      _OneWaySeatSelectionPageState();
}

class _OneWaySeatSelectionPageState extends State<OneWaySeatSelectionPage> {
  late List<List<SeatInfo>> _seatMap;
  String? _selectedSeat;
  double _seatPrice = 0;
  final FlightController _controller = Get.find<FlightController>();

  @override
  void initState() {
    super.initState();
    _seatMap = _controller.getSeatMapFromApi().cast<List<SeatInfo>>();
  }

  double get _tripTotal {
    final farePrice =
        widget.booking.flight.price * widget.booking.fare.priceMultiplier;
    return farePrice + _seatPrice;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark ? const Color(0xFF0B0F1A) : Colors.white;
    final flight = widget.booking.flight;
    final routeSubtitle =
        '${flight.fromCity} to ${flight.toCity.split(' (').first}';

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: BookingAppBar(
        title: 'Choose your seats',
        subtitle: routeSubtitle,
      ),
      body: Column(
        children: [
          const BookingStepIndicator(currentStep: 1),
          // Segment pills
          _buildSegmentPills(context),
          // Traveler info
          _buildTravelerInfo(context),
          // Cabin label
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              flight.cabin,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Seat map
          Expanded(
            child: SharedSeatMap(
              seatMap: _seatMap,
              selectedSeat: _selectedSeat,
              onSeatSelected: (seatLabel, price) {
                setState(() {
                  if (_selectedSeat == seatLabel) {
                    _selectedSeat = null;
                    _seatPrice = 0;
                  } else {
                    _selectedSeat = seatLabel;
                    _seatPrice = price;
                  }
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BookingBottomBar(
        tripTotal: _tripTotal,
        buttonLabel: 'Next: Bags',
        topLabel: 'Seats total',
        topAmount: _seatPrice,
        onPressed: () {
          final updatedBooking = widget.booking.copyWith(
            selectedSeat: _selectedSeat,
            seatPrice: _seatPrice,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OneWayBagsPage(booking: updatedBooking),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSegmentPills(BuildContext context) {
    final flight = widget.booking.flight;
    final fromName = flight.fromCity.split(' (').first;
    final toName = flight.toCity.split(' (').first;

    // If flight has stops, show two segments
    final hasStop = flight.stops != 'Nonstop';
    String? layoverCity;
    if (hasStop && flight.layoverInfo != null) {
      final match = RegExp(r'in (\w+)').firstMatch(flight.layoverInfo!);
      layoverCity = match?.group(1);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          _segmentPill(
            context,
            '$fromName – ${layoverCity ?? toName}',
            selected: true,
          ),
          if (hasStop && layoverCity != null) ...[
            const SizedBox(width: 8),
            _segmentPill(context, '$layoverCity – $toName', selected: false),
          ],
        ],
      ),
    );
  }

  Widget _segmentPill(
    BuildContext context,
    String label, {
    required bool selected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? (isDark ? const Color(0xFF1A2340) : const Color(0xFFE3F2FD))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? const Color(0xFF1565C0)
              : (isDark ? const Color(0xFF2A3141) : Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A2340) : const Color(0xFFE8EAF6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.booking.flight.airline.substring(0, 1),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelerInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark
        ? const Color(0xFF7FB5FF)
        : const Color(0xFF1565C0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            'Traveler 1',
            style: TextStyle(
              color: accentColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _selectedSeat != null ? 'Seat $_selectedSeat' : 'No seat selected',
            style: TextStyle(color: accentColor, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 120,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }


}
