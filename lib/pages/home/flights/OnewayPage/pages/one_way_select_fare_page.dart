import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/flight_controller.dart';
import '../models/one_way_models.dart';
import 'one_way_review_trip_page.dart';

/// Page 3: Select fare — shows flight header + horizontally scrollable fare cards.
class OneWaySelectFarePage extends StatelessWidget {
  final OneWayFlight flight;
  final OneWaySearchCriteria criteria;

  const OneWaySelectFarePage({
    super.key,
    required this.flight,
    required this.criteria,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark
        ? const Color(0xFF0B0F1A)
        : const Color(0xFFF5F5F5);
    final destCity = flight.toCity.split(' (').first;
    final controller = Get.find<FlightController>();

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
          'Select fare to $destCity',
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
            _buildFlightHeader(context),
            const SizedBox(height: 16),
            // Horizontally scrollable fare cards
            Obx(() {
              final fares = controller.getFaresFromApi();
              return SizedBox(
                height: 520,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: fares.length,
                  itemBuilder: (context, index) {
                    return _buildFareCard(context, fares[index]);
                  },
                ),
              );
            }),
            const SizedBox(height: 24),
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
          Text(
            '${flight.departTime} - ${flight.arriveTime} (${flight.duration}, ${flight.stops})',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A2340)
                      : const Color(0xFFE8EAF6),
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
                style: TextStyle(color: colors.onSurface, fontSize: 14),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.wifi,
                size: 18,
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.usb,
                size: 18,
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.personal_video,
                size: 18,
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E2433)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Average CO₂',
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

  Widget _buildFareCard(BuildContext context, FareOption fare) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;

    final farePrice = flight.price * fare.priceMultiplier;
    final priceWhole = NumberFormat.simpleCurrency(
      name: 'USD',
      decimalDigits: 0,
    ).format(farePrice);
    final priceExact = NumberFormat.simpleCurrency(
      name: 'USD',
    ).format(farePrice);

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
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
              '$priceExact one way for 1 traveler',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.55),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              fare.name,
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
            // Feature list
            ...fare.features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildFeatureRow(context, f),
              ),
            ),
            const Spacer(),
            // Select button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final booking = OneWayBooking(
                    criteria: criteria,
                    flight: flight,
                    fare: fare,
                  );
                  
                  // controller.selectOffer is now called before this page opens

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OneWayReviewTripPage(booking: booking),
                    ),
                  );
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

  Widget _buildFeatureRow(BuildContext context, FareFeature feature) {
    final colors = Theme.of(context).colorScheme;

    IconData icon;
    Color iconColor;
    switch (feature.type) {
      case FareFeatureType.included:
        icon = Icons.check_circle;
        iconColor = const Color(0xFF2E7D32);
        break;
      case FareFeatureType.paid:
        icon = Icons.attach_money;
        iconColor = const Color(0xFF1565C0);
        break;
      case FareFeatureType.notIncluded:
        icon = Icons.close;
        iconColor = colors.onSurface.withValues(alpha: 0.5);
        break;
    }

    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            feature.text,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
