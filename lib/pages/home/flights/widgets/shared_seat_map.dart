import 'package:flutter/material.dart';
import '../OnewayPage/models/seat_model.dart';

class SharedSeatMap extends StatelessWidget {
  final List<List<SeatInfo>> seatMap;
  final String? selectedSeat;
  final Function(String, double) onSeatSelected;

  const SharedSeatMap({
    super.key,
    required this.seatMap,
    required this.selectedSeat,
    required this.onSeatSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildColumnHeaders(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                for (int rowIdx = 0; rowIdx < seatMap.length; rowIdx++)
                  _buildSeatRow(context, rowIdx),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColumnHeaders(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cols = ['A', 'B', 'C', '', 'D', 'E', 'F'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const SizedBox(width: 24), // row number space
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
          const SizedBox(width: 24), // row number space right
        ],
      ),
    );
  }

  Widget _buildSeatRow(BuildContext context, int rowIdx) {
    final colors = Theme.of(context).colorScheme;
    final row = seatMap[rowIdx];
    final rowNumber = rowIdx + 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      child: Row(
        children: [
          // Row number left
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
          // Seats
          ...row.map((seat) {
            if (seat.label.isEmpty) {
              // Aisle
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
          // Row number right
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
              double price = seat.extraPrice > 0 ? seat.extraPrice : 53.0;
              onSeatSelected(seat.label, price);
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
