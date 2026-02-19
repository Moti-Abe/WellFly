import 'package:flutter/material.dart';
import '../../widgets/travel_image_section.dart';
import '../OnewayPage/models/one_way_models.dart';
import '../OnewayPage/pages/one_way_recommended_page.dart';
import 'flight_date_field.dart';
import 'flight_text_field.dart';
import 'search_button.dart';
import 'traveler_modal.dart';
import 'city_search_screen.dart';

class OneWayWidget extends StatefulWidget {
  const OneWayWidget({super.key});

  @override
  State<OneWayWidget> createState() => _OneWayState();
}

class _OneWayState extends State<OneWayWidget> {
  final _formKey = GlobalKey<FormState>();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final departController = TextEditingController();
  DateTime? _selectedDate;

  int travelers = 1;
  String cabinClass = "Economy";

  void _swapCities() {
    setState(() {
      String temp = fromController.text;
      fromController.text = toController.text;
      toController.text = temp;
    });
  }

  void _openCitySearch(String type) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitySearchScreen(title: "Select $type"),
      ),
    );
    if (result != null) {
      setState(() {
        if (type == "From") {
          fromController.text = result;
        } else {
          toController.text = result;
        }
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
      builder: (context) => TravelerModal(
        initialAdults: travelers, // Matches the fixed constructor
        initialCabin: cabinClass,
      ),
    );

    if (result != null) {
      setState(() {
        travelers = result['adults']; // Returns total count from Modal
        cabinClass = result['cabin'];
      });
    }
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
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Column(
                  children: [
                    FlightTextField(
                      label: "Leaving from",
                      icon: Icons.location_on,
                      controller: fromController,
                      onTap: () => _openCitySearch("From"),
                    ),
                    FlightTextField(
                      label: "Going to",
                      icon: Icons.location_on,
                      controller: toController,
                      onTap: () => _openCitySearch("To"),
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
            FlightDateField(
              label: "Dates",
              controller: departController,
              onDatePicked: (date) {
                _selectedDate = date;
              },
            ),
            const SizedBox(height: 12),
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
                      "$travelers ${travelers > 1 ? 'Travelers' : 'Traveler'}, $cabinClass",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SearchButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final criteria = OneWaySearchCriteria(
                    from: fromController.text,
                    to: toController.text,
                    departDate: _selectedDate ?? DateTime.now(),
                    travelers: travelers,
                    cabinClass: cabinClass,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OneWayRecommendedPage(criteria: criteria),
                    ),
                  );
                }
              },
            ),
            const TravelImageSection(),
          ],
        ),
      ),
    );
  }
}
