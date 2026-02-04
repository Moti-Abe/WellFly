import 'package:flutter/material.dart';
import 'widgets/flight_text_field.dart.dart';
import 'widgets/flight_date_field.dart';
import 'widgets/big_month_deals.dart';
import 'widgets/bundle_save_card.dart';
import 'widgets/your_trip_card.dart';
import 'widgets/travel_shops.dart';
import '../flights/widgets/cabin_dropdown.dart';
import 'widgets/search_button.dart';

class RoundtripPage extends StatefulWidget {
  const RoundtripPage({super.key});

  @override
  State<RoundtripPage> createState() => _RoundtripFormState();
}

class _RoundtripFormState extends State<RoundtripPage> {
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
              label: "From",
              icon: Icons.flight_takeoff,
              controller: fromController,
              validator: (v) => v!.isEmpty ? "Enter departure city" : null,
            ),
            FlightTextField(
              label: "To",
              icon: Icons.flight_land,
              controller: toController,
              validator: (v) => v!.isEmpty ? "Enter destination city" : null,
            ),
            FlightDateField(
              label: "Depart date",
              controller: departController,
              onTap: () => _pickDate(departController),
            ),
            FlightDateField(
              label: "Return date",
              controller: returnController,
              onTap: () => _pickDate(returnController),
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
