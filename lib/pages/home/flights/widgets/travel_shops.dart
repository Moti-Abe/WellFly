import 'package:flutter/material.dart';

class TravelShops extends StatelessWidget {
  const TravelShops({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            "Explore more with Travel Shops",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _shopCard("assets/images/shop1.webp", "Candace Molatore"),
              _shopCard("assets/images/shop2.jpg", "James Carter"),
              _shopCard("assets/images/shop3.jpeg", "Emily Watson"),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: () {}, child: const Text("View more shops →")),
      ],
    );
  }

  Widget _shopCard(String image, String name) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 8,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: const Icon(Icons.person),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
