import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/flight_controller.dart';
import '../models/round_trip_models.dart';
import '../widgets/rt_step_indicator.dart';
import '../widgets/rt_bottom_bar.dart';
import 'rt_secure_booking_page.dart';

/// Page 7: Add your bags — shows included bags and extra options.
class RtBagsPage extends StatefulWidget {
  final RoundTripBooking booking;

  const RtBagsPage({super.key, required this.booking});

  @override
  State<RtBagsPage> createState() => _RtBagsPageState();
}

class _RtBagsPageState extends State<RtBagsPage> {
  final int _selectedBagIndex = 0;
  late List<RtBaggageOption> _options;
  final FlightController _controller = Get.find<FlightController>();

  @override
  void initState() {
    super.initState();
    _options = _controller.getRtBaggageFromApi();
  }

  double get _bagsTotal => _options[_selectedBagIndex].price;

  double get _tripTotal {
    final dep = widget.booking.departureFlight;
    final ret = widget.booking.returnFlight;
    final fare = widget.booking.fare;
    return dep.price * fare.priceMultiplier +
        ret.price * fare.priceMultiplier +
        widget.booking.totalSeatPrice +
        _bagsTotal;
  }

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
              'Add your bags',
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
          const RtStepIndicator(currentStep: 2),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              children: [
                _buildIncludedBag(
                  context,
                  icon: Icons.luggage_outlined,
                  title: 'Carry-on bag',
                  subtitle: 'up to 15 lbs',
                ),
                const SizedBox(height: 12),
                _buildIncludedBag(
                  context,
                  icon: Icons.luggage,
                  title: '2 checked bags',
                  subtitle: 'up to 50 lbs each',
                ),
                const SizedBox(height: 12),
                _buildInfoCard(context),
                const SizedBox(height: 20),
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
      bottomNavigationBar: RtBottomBar(
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
                  RtSecureBookingPage(booking: updatedBooking),
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
    final dep = widget.booking.departureFlight;

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
              'You can add more bags to your flights by contacting ${dep.airline} after booking.',
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
