import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models.dart';

class MultiCityReviewFarePage extends StatelessWidget {
  final MultiCityFlight flight;
  final VoidCallback onSelect;

  const MultiCityReviewFarePage({
    super.key,
    required this.flight,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground =
        isDark ? const Color(0xFF0B0F1A) : const Color(0xFFF5F5F5);

    final formatter = NumberFormat.simpleCurrency(name: 'USD');
    final priceWhole =
        NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 0)
            .format(flight.price);

    // Extract destination city name (e.g. "London" from "London (LHR)")
    final destCity = flight.toCity.split(' (').first;

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0B0F1A) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Review fare to $destCity',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Flight Summary Header ───
            _buildFlightHeader(context),
            const SizedBox(height: 16),
            // ─── Fare Card ───
            _buildFareCard(context, priceWhole, formatter),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final headerBg = isDark ? const Color(0xFF111624) : Colors.white;

    return Container(
      width: double.infinity,
      color: headerBg,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time - Duration - Stops
          Text(
            '${flight.departTime} - ${flight.arriveTime} (${flight.duration}, ${flight.stops})',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          // Airline row with amenity icons
          Row(
            children: [
              // Airline logo circle
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A2340)
                      : colors.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    flight.airline.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF7FB5FF)
                          : const Color(0xFF1565C0),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                flight.airline,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              // Amenity icons
              Icon(Icons.wifi, size: 18, color: colors.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 8),
              Icon(Icons.usb, size: 18, color: colors.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 8),
              Icon(Icons.personal_video,
                  size: 18, color: colors.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 12),
              // Carbon badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E2433)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Above average CO₂',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFareCard(
    BuildContext context,
    String priceWhole,
    NumberFormat formatter,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;

    final exactPrice = formatter.format(flight.price);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Price ──
            Text(
              priceWhole,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$exactPrice multi-city trip for 1 traveler',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.55),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            // ── Economy Good Deal ──
            Text(
              '${flight.cabin} Deal',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Cabin: ${flight.cabin}',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            // ── Feature list ──
            _buildFeatureRow(
              context,
              icon: Icons.attach_money,
              iconColor: const Color(0xFF1565C0),
              text: 'Seat choice for a fee',
            ),
            const SizedBox(height: 12),
            _buildFeatureRow(
              context,
              icon: Icons.check_circle,
              iconColor: const Color(0xFF2E7D32),
              text: 'Carry-on bag included',
            ),
            const SizedBox(height: 12),
            _buildFeatureRow(
              context,
              icon: Icons.check_circle,
              iconColor: const Color(0xFF2E7D32),
              text: '2 checked bags included (50 lbs each)',
            ),
            const SizedBox(height: 12),
            _buildFeatureRow(
              context,
              icon: Icons.close,
              iconColor: colors.onSurface.withValues(alpha: 0.5),
              text: 'Non-refundable',
            ),
            const SizedBox(height: 12),
            _buildFeatureRow(
              context,
              icon: Icons.attach_money,
              iconColor: const Color(0xFF1565C0),
              text: 'Change fee:',
              trailingText: '\$100',
            ),
            const SizedBox(height: 24),
            // ── Select Button ──
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close review fare
                  onSelect(); // Trigger the segment selection
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Select'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String text,
    String? trailingText,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 22, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 14,
            ),
          ),
        ),
        if (trailingText != null)
          Text(
            trailingText,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
