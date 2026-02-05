import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../account/payment_methods_page.dart';
import '../account/profile_page.dart';
import '../account/settings_page.dart';
import '../home/auth/sign_in_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hi, Tuamay",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Tuamay@email.com",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Get.to(() => ProfilePage());
              },
            ),

            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text("Payment Methods"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Get.to(() => const PaymentMethodsPage());
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Get.to(() => SettingsPage());
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Get.to(() => const SignInPage());
                },
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
