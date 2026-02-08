import 'package:flutter/material.dart';
import '../payment/widgets/account_tile.dart';
import '../payment/widgets/travel_arranger_content.dart';

class MyAccountTab extends StatefulWidget {
  const MyAccountTab({super.key});

  @override
  State<MyAccountTab> createState() => _MyAccountTabState();
}

class _MyAccountTabState extends State<MyAccountTab> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AccountTile(
          title: "Payment Method",
          icon: Icons.credit_card,
          isSelected: selectedIndex == 0,
          onTap: () {
            setState(() {
              selectedIndex = selectedIndex == 0 ? -1 : 0;
            });
          },
          expandedContent: const Text("You have no saved cards."),
        ),

        AccountTile(
          title: "Connected Accounts",
          icon: Icons.link,
          isSelected: selectedIndex == 1,
          onTap: () {
            setState(() {
              selectedIndex = selectedIndex == 1 ? -1 : 1;
            });
          },
          expandedContent: Row(
            children: [
              Image.asset("assets/images/google.png", width: 25),
              const SizedBox(width: 12),
              const Text("Google - Tuamay@gmail.com"),
            ],
          ),
        ),

        AccountTile(
          title: "Travel Arranger",
          icon: Icons.business_center,
          isSelected: selectedIndex == 2,
          onTap: () {
            setState(() {
              selectedIndex = selectedIndex == 2 ? -1 : 2;
            });
          },
          expandedContent: const TravelArrangerContent(),
        ),
      ],
    );
  }
}
