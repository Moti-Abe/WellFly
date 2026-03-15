import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expedia/pages/home/flights/OnewayPage/models/seat_model.dart';
import '../../controllers/flight_controller.dart';
import '../models/round_trip_models.dart';
import '../widgets/rt_step_indicator.dart';
import '../widgets/rt_bottom_bar.dart';
import 'rt_bags_page.dart';

/// Page 6: Seat selection for both departure and return flights.
class RtSeatSelectionPage extends StatefulWidget {
  final RoundTripBooking booking;

  const RtSeatSelectionPage({super.key, required this.booking});

  @override
  State<RtSeatSelectionPage> createState() => _RtSeatSelectionPageState();
}

class _RtSeatSelectionPageState extends State<RtSeatSelectionPage> {
  late List<List<SeatInfo>> _departSeatMap;
  late List<List<SeatInfo>> _returnSeatMap;

  // 0 = departure, 1 = return
  int _activeSegment = 0;

  String? _departSeat;
  double _departSeatPrice = 0;
  String? _returnSeat;
  double _returnSeatPrice = 0;
  final FlightController _controller = Get.find<FlightController>();

  @override
  void initState() {
    super.initState();
    _departSeatMap = _controller.getRtSeatMapFromApi().cast<List<SeatInfo>>();
    _returnSeatMap = _controller.getRtSeatMapFromApi().cast<List<SeatInfo>>();
  }

  double get _totalSeatPrice => _departSeatPrice + _returnSeatPrice;

  double get _tripTotal {
    final dep = widget.booking.departureFlight;
    final ret = widget.booking.returnFlight;
    final fare = widget.booking.fare;
    return dep.price * fare.priceMultiplier +
        ret.price * fare.priceMultiplier +
        _totalSeatPrice;
  }

  List<List<SeatInfo>> get _activeSeatMap =>
      _activeSegment == 0 ? _departSeatMap : _returnSeatMap;

  String? get _activeSeat => _activeSegment == 0 ? _departSeat : _returnSeat;

  RoundTripFlight get _activeFlight => _activeSegment == 0
      ? widget.booking.departureFlight
      : widget.booking.returnFlight;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark ? const Color(0xFF0B0F1A) : Colors.white;
    final dep = widget.booking.departureFlight;
    final fromName = dep.fromCity.split(' (').first;
    final toName = dep.toCity.split(' (').first;
    final routeSubtitle = '$fromName to $toName';

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0B0F1A) : Colors.white,
        elevation: 0,
        foregroundColor: colors.onSurface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your seats',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              routeSubtitle,
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const RtStepIndicator(currentStep: 1),
          // Segment toggle (departure / return)
          _buildSegmentToggle(context),
          _buildTravelerInfo(context),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _activeFlight.cabin,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildColumnHeaders(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  for (int i = 0; i < _activeSeatMap.length; i++)
                    _buildSeatRow(context, i),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: RtBottomBar(
        tripTotal: _tripTotal,
        buttonLabel: 'Next: Bags',
        topLabel: 'Seats total',
        topAmount: _totalSeatPrice,
        onPressed: () {
          final updatedBooking = widget.booking.copyWith(
            departureSeat: _departSeat,
            departureSeatPrice: _departSeatPrice,
            returnSeat: _returnSeat,
            returnSeatPrice: _returnSeatPrice,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RtBagsPage(booking: updatedBooking),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSegmentToggle(BuildContext context) {
    final dep = widget.booking.departureFlight;
    final ret = widget.booking.returnFlight;
    final fromName = dep.fromCity.split(' (').first;
    final toName = dep.toCity.split(' (').first;
    final retFromName = ret.fromCity.split(' (').first;
    final retToName = ret.toCity.split(' (').first;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          _segmentPill(
            context,
            '$fromName – $toName',
            selected: _activeSegment == 0,
            onTap: () => setState(() => _activeSegment = 0),
          ),
          const SizedBox(width: 8),
          _segmentPill(
            context,
            '$retFromName – $retToName',
            selected: _activeSegment == 1,
            onTap: () => setState(() => _activeSegment = 1),
          ),
        ],
      ),
    );
  }

  Widget _segmentPill(
    BuildContext context,
    String label, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                color: isDark
                    ? const Color(0xFF1A2340)
                    : const Color(0xFFE8EAF6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _activeSegment == 0
                      ? widget.booking.departureFlight.airline.substring(0, 1)
                      : widget.booking.returnFlight.airline.substring(0, 1),
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
      ),
    );
  }

  Widget _buildTravelerInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark
        ? const Color(0xFF7FB5FF)
        : const Color(0xFF1565C0);
    final seat = _activeSeat;

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
            seat != null ? 'Seat $seat' : 'No seat selected',
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

  Widget _buildColumnHeaders(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cols = ['A', 'B', 'C', '', 'D', 'E', 'F'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const SizedBox(width: 24),
          ...cols.map(
            (col) => Expanded(
              child: Center(
                child: Text(
                  col,
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildSeatRow(BuildContext context, int rowIdx) {
    final colors = Theme.of(context).colorScheme;
    final row = _activeSeatMap[rowIdx];
    final rowNumber = rowIdx + 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.5),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          ...row.map((seat) {
            if (seat.label.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    '$rowNumber',
                    style: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.5),
                      fontSize: 11,
                    ),
                  ),
                ),
              );
            }
            return Expanded(child: _buildSeat(context, seat));
          }),
          SizedBox(
            width: 24,
            child: Text(
              '$rowNumber',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.5),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeat(BuildContext context, SeatInfo seat) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final selectedSeat = _activeSeat;
    final isSelected = selectedSeat == seat.label;
    final isOccupied = seat.type == SeatType.occupied;

    Color bgColor;
    Color textColor;
    String displayText;

    if (isSelected) {
      bgColor = const Color(0xFF1565C0);
      textColor = Colors.white;
      displayText = 'T1';
    } else if (isOccupied) {
      bgColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade300;
      textColor = Colors.transparent;
      displayText = '×';
    } else {
      bgColor = isDark ? const Color(0xFF1E2433) : Colors.grey.shade100;
      textColor = colors.onSurface;
      displayText = seat.extraPrice > 0
          ? '\$${seat.extraPrice.toInt()}'
          : '\$53';
    }

    return GestureDetector(
      onTap: isOccupied
          ? null
          : () {
              setState(() {
                final price = seat.extraPrice > 0 ? seat.extraPrice : 53.0;
                if (_activeSegment == 0) {
                  if (_departSeat == seat.label) {
                    _departSeat = null;
                    _departSeatPrice = 0;
                  } else {
                    _departSeat = seat.label;
                    _departSeatPrice = price;
                  }
                } else {
                  if (_returnSeat == seat.label) {
                    _returnSeat = null;
                    _returnSeatPrice = 0;
                  } else {
                    _returnSeat = seat.label;
                    _returnSeatPrice = price;
                  }
                }
              });
            },
      child: Container(
        height: 38,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: isOccupied
              ? null
              : Border.all(
                  color: isSelected
                      ? const Color(0xFF1565C0)
                      : (isDark
                            ? const Color(0xFF3A4556)
                            : Colors.grey.shade400),
                  width: isSelected ? 2 : 1,
                ),
        ),
        child: Center(
          child: isOccupied
              ? Icon(
                  Icons.close,
                  size: 14,
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
                )
              : Text(
                  displayText,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
