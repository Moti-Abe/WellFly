import 'package:flutter/material.dart';

class ThingsDateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;

  const ThingsDateField({
    super.key,
    required this.label,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
