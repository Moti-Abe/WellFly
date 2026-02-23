import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/round_trip_models.dart';

/// Reusable flight card matching Expedia style for round-trip flights.
class RtFlightCard extends StatelessWidget {
  final RoundTripFlight flight;
  final VoidCallback onSelect;
  final VoidCallback? onFlightDetails;

  const RtFlightCard({
    super.key,
    required this.flight,
    required this.onSelect,
    this.onFlightDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;
    final textColor = colors.onSurface;
    final mutedColor = colors.onSurface.withValues(alpha: 0.6);

    final priceText = NumberFormat.simpleCurrency(
      name: 'USD',
      decimalDigits: 0,
    ).format(flight.price);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onSelect,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Airline icon + times + price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAirlineIcon(context),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                flight.departTime,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              _buildTimeConnector(isDark),
                              const SizedBox(width: 6),
                              Text(
                                flight.arriveTime,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (flight.seatsLeft != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              '${flight.seatsLeft} left',
                              style: const TextStyle(
                                color: Color(0xFFC62828),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        Text(
                          priceText,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Row 2: Route + duration + stops
                Row(
                  children: [
                    const SizedBox(width: 38), // align with text above
                    Expanded(
                      child: Text(
                        '${flight.fromCode}(${_shortCity(flight.fromCity)}) - ${_shortCity(flight.toCity)}(${flight.toCode})',
                        style: TextStyle(color: mutedColor, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const SizedBox(width: 38),
                    Expanded(
                      child: Text(
                        '${flight.duration}  ·  ${flight.stops}',
                        style: TextStyle(color: mutedColor, fontSize: 13),
                      ),
                    ),
                    Text(
                      'per traveler',
                      style: TextStyle(color: mutedColor, fontSize: 12),
                    ),
                  ],
                ),
                if (flight.layoverInfo != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const SizedBox(width: 38),
                      Expanded(
                        child: Text(
                          flight.layoverInfo!,
                          style: TextStyle(color: mutedColor, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
                if (flight.operatedBy != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const SizedBox(width: 38),
                      Expanded(
                        child: Text(
                          'Operated by ${flight.operatedBy}',
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                // Flight details link
                GestureDetector(
                  onTap: onFlightDetails ?? () {},
                  child: Text(
                    'Flight details',
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF7FB5FF)
                          : const Color(0xFF1565C0),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAirlineIcon(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2340) : const Color(0xFFE8EAF6),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          flight.airline.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: isDark ? const Color(0xFF7FB5FF) : const Color(0xFF1565C0),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _shortCity(String city) {
    return city.split(' (').first;
  }

  Widget _buildTimeConnector(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? Colors.white54 : Colors.grey,
              width: 1,
            ),
          ),
        ),
        Container(
          width: 30,
          height: 1,
          color: isDark ? Colors.white24 : Colors.grey.shade400,
        ),
        Icon(
          Icons.flight,
          size: 14,
          color: isDark ? Colors.white54 : Colors.grey,
        ),
        Container(
          width: 30,
          height: 1,
          color: isDark ? Colors.white24 : Colors.grey.shade400,
        ),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? Colors.white54 : Colors.grey,
              width: 1,
            ),
          ),
        ),
      ],
    );
  }
}
