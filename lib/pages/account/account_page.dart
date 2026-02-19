import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/account_header.dart';
import 'widgets/onekey_card.dart';
import 'widgets/account_card_item.dart';
import 'ceredits.dart';
import 'communication/communication.dart';
import 'help_and_feedback.dart';
import 'legal.dart';
import 'reviews.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import '../home/auth/auth_controller.dart';
import 'payment/payment_methods_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const AccountHeader(),

            const SizedBox(height: 20),

            const OneKeyCard(),

            const SizedBox(height: 20),

            AccountCardItem(
              icon: Icons.person,
              title: "Profile",
              onTap: () => Get.to(() => ProfilePage()),
            ),
            AccountCardItem(
              icon: Icons.credit_card,
              title: "Payment Methods",
              onTap: () => Get.to(() => const PaymentMethodsPage()),
            ),
            AccountCardItem(
              icon: Icons.safety_check,
              title: "Credits",
              onTap: () => Get.to(() => Ceredits()),
            ),
            AccountCardItem(
              icon: Icons.message,
              title: "Communication",
              onTap: () => Get.to(() => CommunicationPage()),
            ),
            AccountCardItem(
              icon: Icons.rate_review,
              title: "Reviews",
              onTap: () => Get.to(() => Reviews()),
            ),
            AccountCardItem(
              icon: Icons.settings,
              title: "Security and Settings",
              onTap: () => Get.to(() => SettingsPage()),
            ),
            AccountCardItem(
              icon: Icons.gavel,
              title: "Legal",
              onTap: () => Get.to(() => Legal()),
            ),
            AccountCardItem(
              icon: Icons.question_mark,
              title: "Help and feedback",
              onTap: () => Get.to(() => FeedbackPage()),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Get.find<AuthController>().logout();
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
