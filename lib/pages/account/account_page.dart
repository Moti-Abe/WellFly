import 'package:expedia/pages/account/ceredits.dart';
import 'package:expedia/pages/account/communication/communication.dart';
import 'package:expedia/pages/account/help_and_feedback.dart';
import 'package:expedia/pages/account/legal.dart';
import 'package:expedia/pages/account/reviews.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'payment/payment_methods_page.dart';
import '../account/profile_page.dart';
import '../account/settings_page.dart';
import '../home/auth/sign_in_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hi, Tuamay",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text("Tuamay@email.com", style: TextStyle(color: Colors.grey)),

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
            leading: const Icon(Icons.safety_check),
            title: const Text("Ceredits"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.to(() => Ceredits());
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text("Communication"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.to(() => CommunicationPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: const Text("Reviews"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.to(() => Reviews());
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
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text("legal"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.to(() => Legal());
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text("Help and feedback"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.to(() => HelpAndFeedback());
            },
          ),
          SizedBox(height: 10),
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
    );
  }
}
