import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/flight_text_field.dart';
import '../widgets/search_button.dart';
import '../../widgets/travel_image_section.dart';
import '../widgets/traveler_modal.dart';
import '../widgets/city_search_screen.dart';
import 'models/round_trip_models.dart';
import 'pages/rt_departing_flights_page.dart';

/// Round-trip search form (Page 1).
class RoundtripPage extends StatefulWidget {
  const RoundtripPage({super.key});

  @override
  State<RoundtripPage> createState() => _RoundtripPageState();
}

class _RoundtripPageState extends State<RoundtripPage> {
  final _formKey = GlobalKey<FormState>();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateRangeController = TextEditingController();

  DateTime? _departDate;
  DateTime? _returnDate;
  int travelers = 1;
  String cabinClass = 'Economy';

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    dateRangeController.dispose();
    super.dispose();
  }

  void _swapCities() {
    setState(() {
      final temp = fromController.text;
      fromController.text = toController.text;
      toController.text = temp;
    });
  }

  void _openCitySearch(String type) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitySearchScreen(title: 'Select $type'),
      ),
    );
    if (result != null) {
      setState(() {
        if (type == 'From') {
          fromController.text = result;
        } else {
          toController.text = result;
        }
      });
    }
  }

  void _pickDateRange() async {
    final now = DateTime.now();
    final initialStart = _departDate ?? now;
    final initialEnd = _returnDate ?? now.add(const Duration(days: 3));

    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(2030),
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
    );

    if (picked != null) {
      setState(() {
        _departDate = picked.start;
        _returnDate = picked.end;
        final fmt = DateFormat('EEE, MMM d');
        dateRangeController.text =
            '${fmt.format(picked.start)} - ${fmt.format(picked.end)}';
      });
    }
  }

  void _showTravelerModal() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          TravelerModal(initialAdults: travelers, initialCabin: cabinClass),
    );
    if (result != null) {
      setState(() {
        travelers = result['adults'];
        cabinClass = result['cabin'];
      });
    }
  }

  void _performSearch() {
    if (!_formKey.currentState!.validate()) return;

    final criteria = RoundTripSearchCriteria(
      from: fromController.text,
      to: toController.text,
      departDate: _departDate ?? DateTime.now(),
      returnDate: _returnDate ?? DateTime.now().add(const Duration(days: 3)),
      travelers: travelers,
      cabinClass: cabinClass,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RtDepartingFlightsPage(criteria: criteria),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // From / To fields with swap button
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Column(
                  children: [
                    FlightTextField(
                      label: 'Leaving from',
                      icon: Icons.location_on,
                      controller: fromController,
                      onTap: () => _openCitySearch('From'),
                    ),
                    FlightTextField(
                      label: 'Going to',
                      icon: Icons.location_on,
                      controller: toController,
                      onTap: () => _openCitySearch('To'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12, bottom: 12),
                  child: GestureDetector(
                    onTap: _swapCities,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E2433) : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF2A3141)
                              : Colors.grey.shade400,
                        ),
                        boxShadow: isDark
                            ? []
                            : const [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                      ),
                      child: Icon(
                        Icons.swap_vert,
                        color: isDark ? Colors.white70 : Colors.blue,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Departure & Return (single field)
            _buildDateTile(
              icon: Icons.calendar_today,
              label: 'Sun, Feb 22 - Wed, Feb 25',
              controller: dateRangeController,
              onTap: _pickDateRange,
            ),
            const SizedBox(height: 12),

            // Travelers
            GestureDetector(
              onTap: _showTravelerModal,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people_outline, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text(
                      '$travelers ${travelers > 1 ? 'Travelers' : 'Traveler'}, $cabinClass',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            SearchButton(onPressed: _performSearch),
            const TravelImageSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTile({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.blue),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty) return 'Required';
            return null;
          },
        ),
      ),
    );
  }
}
