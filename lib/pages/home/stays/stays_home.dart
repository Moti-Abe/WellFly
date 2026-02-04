import 'package:flutter/material.dart';
import '../../home/flights/widgets/flight_text_field.dart.dart';
import '../../home/flights/widgets/flight_date_field.dart';
import '../../home/flights/widgets/cabin_dropdown.dart';
import '../../home/flights/widgets/search_button.dart';
import '../../home/flights/widgets/your_trip_card.dart';
import '../../home/flights/widgets/bundle_save_card.dart';
import '../../home/flights/widgets/big_month_deals.dart';
import '../../home/flights/widgets/travel_shops.dart';

class StaysPage extends StatefulWidget {
  const StaysPage({super.key});

  @override
  State<StaysPage> createState() => _StaysPageState();
}

class _StaysPageState extends State<StaysPage> {
  final _formKey = GlobalKey<FormState>();

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final departController = TextEditingController();
  final returnController = TextEditingController();
  final travelersController = TextEditingController(text: "1");

  String cabinClass = "Economy";
  bool addStay = false;

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      controller.text = picked.toString().split(" ")[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FlightTextField(
              label: "Where to?",
              icon: Icons.flight_takeoff,
              controller: fromController,
              validator: (v) => v!.isEmpty ? "Enter departure city" : null,
            ),
            FlightDateField(
              label: "From date",
              controller: departController,
              onTap: () => _pickDate(departController),
            ),
            FlightDateField(
              label: "To date",
              controller: departController,
              onTap: () => _pickDate(departController),
            ),
            FlightTextField(
              label: "Travelers",
              icon: Icons.people,
              controller: travelersController,
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? "Enter travelers" : null,
            ),
            CabinDropdown(
              value: cabinClass,
              onChanged: (value) {
                setState(() {
                  cabinClass = value!;
                });
              },
            ),
            CheckboxListTile(
              value: addStay,
              onChanged: (v) {
                setState(() {
                  addStay = v!;
                });
              },
              title: const Text("Add stay to bundle and save"),
            ),
            const SizedBox(height: 20),
            SearchButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  debugPrint("Searching flights...");
                }
              },
            ),

            const BigMonthDeals(),

            YourTripCard(
              from: fromController.text,
              to: toController.text,
              depart: departController.text,
              ret: returnController.text,
            ),

            const BundleSaveCard(),
            const TravelShops(),
          ],
        ),
      ),
    );
  }
}
