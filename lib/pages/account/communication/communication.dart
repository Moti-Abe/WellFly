import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../communication/offers_page.dart';
// import '../communication/trip_tools_page.dart';
// import '../communication/travel_edit_page.dart';
import '../communication/partner_offers_page.dart';

class CommunicationPage extends StatelessWidget {
  const CommunicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Communication")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Control what notifications you get.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          const SizedBox(height: 24),

          const Text(
            "Shopping",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.local_offer),
            title: const Text("Offers and recommendations"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => PartnerOffersPage()),
          ),

          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("The travel edit"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => PartnerOffersPage()),
          ),

          ListTile(
            leading: const Icon(Icons.build),
            title: const Text("Trip tools and features"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => PartnerOffersPage()),
          ),

          ListTile(
            leading: const Icon(Icons.handshake),
            title: const Text("Partner offers"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => PartnerOffersPage()),
          ),
          const Text(
            "Bookings",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.local_offer),
            title: const Text("Confirmation and critical updates"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => PartnerOffersPage()),
          ),

          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Reviews"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => PartnerOffersPage()),
          ),

          ListTile(
            leading: const Icon(Icons.build),
            title: const Text("Surveys"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => PartnerOffersPage()),
          ),
        ],
      ),
    );
  }
}
