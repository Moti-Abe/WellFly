import 'package:expedia/pages/account/widgets/email_page.dart';
import 'package:expedia/pages/account/widgets/mobile_page.dart';
import '../account/widgets/setting_card.dart';
import '../account/widgets/change_password_page.dart';
import '../account/widgets/connected_device.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../account/controllers/setting_controller.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final SettingsController controller = Get.put(SettingsController());

  final List<String> languages = ["English", "Amharic"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings ")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SettingsCard(
              icon: Icons.email,
              title: "Email",
              subtitle: "Change your email address",
              onTap: () => Get.to(() => const EmailPage()),
            ),
            SettingsCard(
              icon: Icons.phone,
              title: "Mobile Number",
              subtitle: "Update phone number",
              onTap: () => Get.to(() => const MobilePage()),
            ),
            SettingsCard(
              icon: Icons.lock,
              title: "Change Password",
              subtitle: "Update your password",
              onTap: () => Get.to(() => const ChangePasswordPage()),
            ),
            SettingsCard(
              icon: Icons.devices,
              title: "Connected Devices",
              subtitle: "Manage logged-in devices",
              onTap: () => Get.to(() => const ConnectedDevicesPage()),
            ),
            const Text(
              "App Settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Obx(
              () => ListTile(
                leading: const Icon(Icons.language),
                title: const Text("Language"),
                trailing: DropdownButton<String>(
                  value: controller.language.value,
                  items: languages
                      .map(
                        (lang) =>
                            DropdownMenuItem(value: lang, child: Text(lang)),
                      )
                      .toList(),
                  onChanged: (v) {
                    controller.changeLanguage(v!);
                  },
                ),
              ),
            ),

            const Divider(),

            Obx(
              () => SwitchListTile(
                title: const Text("Dark Mode"),
                secondary: const Icon(Icons.dark_mode),
                value: controller.isDarkMode.value,
                onChanged: controller.toggleTheme,
              ),
            ),

            const Divider(),
          ],
        ),
      ),
    ),
    );
  }
}
