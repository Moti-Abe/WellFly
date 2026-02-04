import 'package:flutter/material.dart';
import '../models/flight_leg.dart';
import '../../widgets/flight_date_field.dart';
import '../../widgets/flight_text_field.dart.dart';

class FlightLegCard extends StatelessWidget {
  final int index;
  final FlightLeg leg;
  final VoidCallback? onDelete;
  final Function(TextEditingController) onPickDate;

  const FlightLegCard({
    super.key,
    required this.index,
    required this.leg,
    required this.onPickDate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Flight ${index + 1}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (onDelete != null)
                  TextButton(
                    onPressed: onDelete,
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
            FlightTextField(
              label: "From",
              icon: Icons.flight_takeoff,
              controller: leg.from,
              validator: (v) => v!.isEmpty ? "Enter city" : null,
            ),
            FlightTextField(
              label: "To",
              icon: Icons.flight_land,
              controller: leg.to,
              validator: (v) => v!.isEmpty ? "Enter city" : null,
            ),
            FlightDateField(
              label: "Date",
              controller: leg.date,
              onTap: () => onPickDate(leg.date),
            ),
          ],
        ),
      ),
    );
  }
}
