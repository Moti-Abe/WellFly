import 'package:flutter/material.dart';

class CabinDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  const CabinDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        // value: value,
        items: const [
          DropdownMenuItem(value: "Economy", child: Text("Economy")),
          DropdownMenuItem(value: "Premium", child: Text("Premium Economy")),
          DropdownMenuItem(value: "Business", child: Text("Business")),
          DropdownMenuItem(value: "First", child: Text("First Class")),
        ],
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: "Cabin class",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
