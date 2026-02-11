import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../communication/partner_offers_controller.dart';

class PartnerOffersPage extends StatelessWidget {
  PartnerOffersPage({super.key});

  final PartnerOffersController controller = Get.put(PartnerOffersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Partner Offers")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Special offers from hotel, airline and other travel partners",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              Obx(
                () => CheckboxListTile(
                  title: const Text("Push notifications"),
                  value: controller.push.value,
                  onChanged: (v) => controller.push.value = v!,
                ),
              ),

              Obx(
                () => CheckboxListTile(
                  title: const Text("Email"),
                  value: controller.email.value,
                  onChanged: (v) => controller.email.value = v!,
                ),
              ),

              Obx(
                () => CheckboxListTile(
                  title: const Text("SMS"),
                  value: controller.sms.value,
                  onChanged: (v) => controller.sms.value = v!,
                ),
              ),

              Obx(() {
                if (!controller.sms.value) return const SizedBox();

                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: controller.countryCode.value,
                          items: controller.countryCodes
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                          onChanged: (v) => controller.countryCode.value = v!,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: "Phone Number",
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Enter phone number";
                              }
                              if (v.length < 6) {
                                return "Invalid number";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: controller.updateCommunication,
                  child: const Text("Update"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
