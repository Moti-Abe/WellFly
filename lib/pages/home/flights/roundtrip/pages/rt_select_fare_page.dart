import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/flight_controller.dart';
import '../models/round_trip_models.dart';
import 'rt_review_trip_page.dart';

/// Page 4: Select fare — shows both flights header + horizontally scrollable fare cards.
class RtSelectFarePage extends StatelessWidget {
  final RoundTripSearchCriteria criteria;
  final RoundTripFlight departureFlight;
  final RoundTripFlight returnFlight;

  const RtSelectFarePage({
    super.key,
    required this.criteria,
    required this.departureFlight,
    required this.returnFlight,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark
        ? const Color(0xFF0B0F1A)
        : const Color(0xFFF5F5F5);
    final destCity = departureFlight.toCity.split(' (').first;
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
          'Select your fare',
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
            _buildFlightHeader(context, 'Departing', departureFlight),
            _buildFlightHeader(context, 'Returning', returnFlight),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Choose a fare to $destCity and back',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final fares = controller.getRtFaresFromApi();
              return SizedBox(
                height: 540,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: fares.length,
                  itemBuilder: (context, index) =>
                      _buildFareCard(context, fares[index]),
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightHeader(
    BuildContext context,
    String label,
    RoundTripFlight flight,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final headerBg = isDark ? const Color(0xFF111624) : Colors.white;

    return Container(
      width: double.infinity,
      color: headerBg,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label  ·  ${flight.dateLabel}',
            style: TextStyle(
              color: isDark ? const Color(0xFF7FB5FF) : const Color(0xFF1565C0),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${flight.departTime} – ${flight.arriveTime} (${flight.duration}, ${flight.stops})',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
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
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                flight.airline,
                style: TextStyle(color: colors.onSurface, fontSize: 13),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.wifi,
                size: 16,
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.usb,
                size: 16,
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.personal_video,
                size: 16,
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFareCard(BuildContext context, RtFareOption fare) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;

    final departFare = departureFlight.price * fare.priceMultiplier;
    final returnFare = returnFlight.price * fare.priceMultiplier;
    final totalFare = departFare + returnFare;
    final priceWhole = NumberFormat.simpleCurrency(
      name: 'USD',
      decimalDigits: 0,
    ).format(totalFare);
    final priceExact = NumberFormat.simpleCurrency(
      name: 'USD',
    ).format(totalFare);

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
              '$priceExact round trip for 1 traveler',
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
              'Cabin: ${departureFlight.cabin}',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            ...fare.features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildFeatureRow(context, f),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final booking = RoundTripBooking(
                    criteria: criteria,
                    departureFlight: departureFlight,
                    returnFlight: returnFlight,
                    fare: fare,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RtReviewTripPage(booking: booking),
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

  Widget _buildFeatureRow(BuildContext context, RtFareFeature feature) {
    final colors = Theme.of(context).colorScheme;

    IconData icon;
    Color iconColor;
    switch (feature.type) {
      case RtFareFeatureType.included:
        icon = Icons.check_circle;
        iconColor = const Color(0xFF2E7D32);
      case RtFareFeatureType.paid:
        icon = Icons.attach_money;
        iconColor = const Color(0xFF1565C0);
      case RtFareFeatureType.notIncluded:
        icon = Icons.close;
        iconColor = colors.onSurface.withValues(alpha: 0.5);
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
