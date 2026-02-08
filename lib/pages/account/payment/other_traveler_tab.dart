import 'package:flutter/material.dart';

class OtherTravelersTab extends StatelessWidget {
  const OtherTravelersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        icon: const Icon(Icons.add),
        label: const Text("Add New Traveler"),
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Coming soon...")));
        },
      ),
    );
  }
}
