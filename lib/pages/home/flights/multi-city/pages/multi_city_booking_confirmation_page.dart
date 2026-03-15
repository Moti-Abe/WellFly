import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models.dart';

class MultiCityBookingConfirmationPage extends StatelessWidget {
  final MultiCitySelection selection;
  final double total;

  const MultiCityBookingConfirmationPage({
    super.key,
    required this.selection,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark
        ? const Color(0xFF0B0F1A)
        : Colors.white;
    final bookingId = _generateBookingId();
    final formatter = NumberFormat.simpleCurrency(name: 'USD');

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        foregroundColor: colors.onSurface,
        title: const Text('Booking confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          _buildHeader(context, bookingId),
          const SizedBox(height: 20),
          _buildSummaryCard(context),
          const SizedBox(height: 18),
          _buildTotalCard(context, formatter.format(total)),
          const SizedBox(height: 30),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('Back to home'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String bookingId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark
        ? const Color(0xFF151A24)
        : colors.surface.withValues(alpha: 0.72);
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking confirmed',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Booking ID: $bookingId',
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.75),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your itinerary is ready. A confirmation email has been sent.',
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark
        ? const Color(0xFF111624)
        : colors.surface.withValues(alpha: 0.72);
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);
    final flight1 = selection.flight1!;
    final flight2 = selection.flight2!;
    final flight3 = selection.flight3;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip summary',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildSegmentRow(context, 'Flight 1', flight1),
          const SizedBox(height: 12),
          _buildSegmentRow(context, 'Flight 2', flight2),
          if (flight3 != null) ...[
            const SizedBox(height: 12),
            _buildSegmentRow(context, 'Flight 3', flight3),
          ],
        ],
      ),
    );
  }

  Widget _buildSegmentRow(
    BuildContext context,
    String label,
    MultiCityFlight flight,
  ) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: Color(0xFF7FB5FF),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label: ${flight.fromCity} to ${flight.toCity}',
                style: TextStyle(color: colors.onSurface, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                '${flight.departTime} - ${flight.arriveTime} · ${flight.dateLabel}',
                style: TextStyle(
                  color: colors.onSurface.withValues(alpha: 0.75),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCard(BuildContext context, String totalText) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark
        ? const Color(0xFF151A24)
        : colors.surface.withValues(alpha: 0.72);
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total paid',
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.75),
              fontSize: 14,
            ),
          ),
          Text(
            totalText,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _generateBookingId() {
    final random = Random();
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final code = List.generate(
      8,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
    return 'MC-$code';
  }
}
