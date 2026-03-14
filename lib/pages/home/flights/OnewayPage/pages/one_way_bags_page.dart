import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/flight_controller.dart';
import '../models/one_way_models.dart';
import '../widgets/booking_app_bar.dart';
import '../widgets/booking_step_indicator.dart';
import '../widgets/booking_bottom_bar.dart';
import 'one_way_secure_booking_page.dart';

/// Page 6: Add your bags — shows included bags and extra options.
class OneWayBagsPage extends StatefulWidget {
  final OneWayBooking booking;

  const OneWayBagsPage({super.key, required this.booking});

  @override
  State<OneWayBagsPage> createState() => _OneWayBagsPageState();
}

class _OneWayBagsPageState extends State<OneWayBagsPage> {
  final int _selectedBagIndex = 0; // default: no extra bags
  late List<BaggageOption> _options;
  final FlightController _controller = Get.find<FlightController>();

  @override
  void initState() {
    super.initState();
    _options = _controller.getBaggageFromApi();
  }

  double get _bagsTotal => _options[_selectedBagIndex].price;

  double get _tripTotal {
    final farePrice =
        widget.booking.flight.price * widget.booking.fare.priceMultiplier;
    return farePrice + widget.booking.seatPrice + _bagsTotal;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBackground = isDark ? const Color(0xFF0B0F1A) : Colors.white;
    final flight = widget.booking.flight;
    final routeSubtitle =
        '${flight.fromCity} to ${flight.toCity.split(' (').first}';

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: BookingAppBar(title: 'Add your bags', subtitle: routeSubtitle),
      body: Column(
        children: [
          const BookingStepIndicator(currentStep: 2),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              children: [
                // Carry-on included
                _buildIncludedBag(
                  context,
                  icon: Icons.luggage_outlined,
                  title: 'Carry-on bag',
                  subtitle: 'up to 15 lbs',
                ),
                const SizedBox(height: 12),
                // Checked bags included (based on fare)
                _buildIncludedBag(
                  context,
                  icon: Icons.luggage,
                  title: '2 checked bags',
                  subtitle: 'up to 50 lbs each',
                ),
                const SizedBox(height: 12),
                // Info card
                _buildInfoCard(context),
                const SizedBox(height: 20),
                // Link
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'Size and weight info',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF7FB5FF)
                              : const Color(0xFF1565C0),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: isDark
                            ? const Color(0xFF7FB5FF)
                            : const Color(0xFF1565C0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BookingBottomBar(
        tripTotal: _tripTotal,
        buttonLabel: 'Next: Checkout',
        topLabel: 'Bags total',
        topAmount: _bagsTotal,
        onPressed: () {
          final updatedBooking = widget.booking.copyWith(
            baggage: _options[_selectedBagIndex],
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OneWaySecureBookingPage(booking: updatedBooking),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIncludedBag(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: colors.onSurface),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Included',
                style: TextStyle(
                  color: colors.onSurface.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;
    final flight = widget.booking.flight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 22,
            color: colors.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You can add more bags to this flight by contacting ${flight.airline} after booking.',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
