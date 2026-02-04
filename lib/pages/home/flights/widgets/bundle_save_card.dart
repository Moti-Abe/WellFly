import 'package:flutter/material.dart';

class BundleSaveCard extends StatelessWidget {
  const BundleSaveCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            "Bundle & Save",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _infoCard(icon: Icons.card_travel, title: "Bundle & Save"),
              _infoCard(icon: Icons.flight, title: "More flights, one search"),
              _infoCard(icon: Icons.attach_money, title: "Upfront pricing"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoCard({required IconData icon, required String title}) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 149, 188, 241),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            onPressed: () {},
            child: const Text("Learn More"),
          ),
        ],
      ),
    );
  }
}
