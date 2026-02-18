import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'car_data.dart';
import 'car_search_screen.dart';
import 'widgets/car_card.dart';

class CarPage extends StatefulWidget {
  const CarPage({super.key});

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime? _pickupDate;
  DateTime? _dropoffDate;

  String _pickupTime = '3:45pm';
  String _dropoffTime = '3:45pm';

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDates() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDateRange: _pickupDate != null && _dropoffDate != null
          ? DateTimeRange(start: _pickupDate!, end: _dropoffDate!)
          : null,
    );
    if (range != null) {
      setState(() {
        _pickupDate = range.start;
        _dropoffDate = range.end;
        _dateController.text =
            '${DateFormat('MMM d').format(range.start)}-${DateFormat('MMM d').format(range.end)}';
      });
    }
  }

  void _showTimePicker({required bool isPickup}) {
    final times = [
      '12:00am',
      '12:30am',
      '1:00am',
      '1:30am',
      '2:00am',
      '2:30am',
      '3:00am',
      '3:30am',
      '4:00am',
      '4:30am',
      '5:00am',
      '5:30am',
      '6:00am',
      '6:30am',
      '7:00am',
      '7:30am',
      '8:00am',
      '8:30am',
      '9:00am',
      '9:30am',
      '10:00am',
      '10:30am',
      '11:00am',
      '11:30am',
      '12:00pm',
      '12:30pm',
      '1:00pm',
      '1:30pm',
      '2:00pm',
      '2:30pm',
      '3:00pm',
      '3:30pm',
      '3:45pm',
      '4:00pm',
      '4:30pm',
      '5:00pm',
      '5:30pm',
      '6:00pm',
      '6:30pm',
      '7:00pm',
      '7:30pm',
      '8:00pm',
      '8:30pm',
      '9:00pm',
      '9:30pm',
      '10:00pm',
      '10:30pm',
      '11:00pm',
      '11:30pm',
    ];

    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  isPickup ? 'Pick-up time' : 'Drop-off time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: times.length,
                  itemBuilder: (ctx, i) {
                    final current = isPickup ? _pickupTime : _dropoffTime;
                    final isSelected = times[i] == current;
                    return ListTile(
                      title: Text(
                        times[i],
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? const Color(0xFF1565C0)
                              : colors.onSurface,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Color(0xFF1565C0))
                          : null,
                      onTap: () {
                        setState(() {
                          if (isPickup) {
                            _pickupTime = times[i];
                          } else {
                            _dropoffTime = times[i];
                          }
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openLocationSearch(
    String label,
    TextEditingController controller,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarLocationSearchScreen(title: label),
      ),
    );
    if (result != null) {
      setState(() {
        controller.text = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ── Search section ──
        _buildSearchSection(context, isDark, colors),

        const SizedBox(height: 8),

        // ── Section title ──
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            'Popular rental cars',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Great deals on rental cars near you',
            style: TextStyle(
              fontSize: 13,
              color: colors.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ),

        // ── Car cards ──
        ...mockCars.map((car) => CarCard(car: car)),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSearchSection(
    BuildContext context,
    bool isDark,
    ColorScheme colors,
  ) {
    final cardBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade300;
    final fieldBg = isDark ? const Color(0xFF111624) : Colors.white;

    return Container(
      color: cardBg,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pick-up location
          _buildLocationField(
            controller: _pickupController,
            hint: 'Pick-up',
            isDark: isDark,
            colors: colors,
            borderColor: borderColor,
            fieldBg: fieldBg,
          ),
          const SizedBox(height: 12),

          // Drop-off location
          _buildLocationField(
            controller: _dropoffController,
            hint: 'Drop-off',
            subtitle: 'Same as pick-up',
            isDark: isDark,
            colors: colors,
            borderColor: borderColor,
            fieldBg: fieldBg,
          ),
          const SizedBox(height: 12),

          // Dates field
          GestureDetector(
            onTap: _pickDates,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                color: fieldBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: colors.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dates',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _dateController.text.isNotEmpty
                            ? _dateController.text
                            : 'Select dates',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Pick-up & Drop-off time row
          Row(
            children: [
              Expanded(
                child: _buildTimeTile(
                  label: 'Pick-up time',
                  value: _pickupTime,
                  isDark: isDark,
                  colors: colors,
                  borderColor: borderColor,
                  fieldBg: fieldBg,
                  onTap: () => _showTimePicker(isPickup: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimeTile(
                  label: 'Drop-off time',
                  value: _dropoffTime,
                  isDark: isDark,
                  colors: colors,
                  borderColor: borderColor,
                  fieldBg: fieldBg,
                  onTap: () => _showTimePicker(isPickup: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Search',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String hint,
    String? subtitle,
    required bool isDark,
    required ColorScheme colors,
    required Color borderColor,
    required Color fieldBg,
  }) {
    return GestureDetector(
      onTap: () => _openLocationSearch(
        subtitle != null ? 'Drop-off location' : 'Pick-up location',
        controller,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: fieldBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 22,
              color: colors.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: subtitle != null && controller.text.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hint,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      controller.text.isNotEmpty ? controller.text : hint,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: controller.text.isNotEmpty
                            ? colors.onSurface
                            : colors.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTile({
    required String label,
    required String value,
    required bool isDark,
    required ColorScheme colors,
    required Color borderColor,
    required Color fieldBg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: fieldBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: colors.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
