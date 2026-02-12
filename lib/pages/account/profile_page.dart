import 'package:expedia/pages/account/payment/payment_methods_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../account/controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController controller = Get.put(ProfileController());

  final _formKey = GlobalKey<FormState>();

  final List<String> genders = ["Male", "Female", "Other"];
  final List<String> countryCodes = ["+251", "+44", "+91"];

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime(2000),
    );

    if (picked != null) {
      controller.dobController.text = picked.toString().split(" ")[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Your Information",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: controller.fullNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v!.isEmpty ? "Enter full name" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Enter email";
                  if (!GetUtils.isEmail(v)) return "Invalid email";
                  return null;
                },
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Obx(
                    () => DropdownButton<String>(
                      value: controller.countryCode.value,
                      items: countryCodes
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (v) {
                        controller.countryCode.value = v!;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Phone Number",
                      ),
                      validator: (v) => v!.isEmpty ? "Enter phone" : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.gender.value,
                  decoration: const InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(),
                  ),
                  items: genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) {
                    controller.gender.value = v!;
                  },
                  validator: (v) => v == null ? "Select gender" : null,
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: controller.dobController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Date of Birth",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _pickDate(context),
                validator: (v) => v!.isEmpty ? "Select date" : null,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.updateProfile();
                    }
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              TextButton(
                onPressed: () {
                  Get.to(() => PaymentMethodsPage());
                },
                child: Text(
                  "Add Additional Traveler",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
