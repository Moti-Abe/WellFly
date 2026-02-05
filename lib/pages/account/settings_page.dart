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
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Travel Preferences",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Language
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

            // Theme
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
    );
  }
}
