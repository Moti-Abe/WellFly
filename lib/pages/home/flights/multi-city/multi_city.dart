import 'package:flutter/material.dart';
import 'models/flight_leg.dart';
import 'widgets/flight_leg_card.dart';
import '../widgets/search_button.dart';
import '../widgets/bundle_save_card.dart';
import '../widgets/big_month_deals.dart';
import '../widgets/travel_shops.dart';

class MultiCityPage extends StatefulWidget {
  const MultiCityPage({super.key});

  @override
  State<MultiCityPage> createState() => _MultiCityPageState();
}

class _MultiCityPageState extends State<MultiCityPage> {
  final _formKey = GlobalKey<FormState>();

  List<FlightLeg> flights = [FlightLeg(), FlightLeg()]; // start with 2

  void addFlight() {
    setState(() {
      flights.add(FlightLeg());
    });
  }

  void removeFlight(int index) {
    if (flights.length > 2) {
      setState(() {
        flights.removeAt(index);
      });
    }
  }

  Future<void> pickDate(TextEditingController controller) async {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // All flights
            ...List.generate(flights.length, (index) {
              return FlightLegCard(
                index: index,
                leg: flights[index],
                onPickDate: pickDate,
                onDelete: flights.length > 2 ? () => removeFlight(index) : null,
              );
            }),

            // Add button
            TextButton.icon(
              onPressed: addFlight,
              icon: const Icon(Icons.add),
              label: const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "Add Another flight",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SearchButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  debugPrint("Searching multi-city...");
                }
              },
            ),
            const BigMonthDeals(),

            // YourTripCard(
            //   from: fromController.text,
            //   to: toController.text,
            //   depart: departController.text,
            // ),
            const BundleSaveCard(),
            const TravelShops(),
          ],
        ),
      ),
    );
  }
}
