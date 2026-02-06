import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final fullName = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final gender = 'Male'.obs;
  final dob = ''.obs;
  final countryCode = '+251'.obs;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();

  void updateProfile() {
    fullName.value = fullNameController.text;
    email.value = emailController.text;
    phone.value = "${countryCode.value}${phoneController.text}";
    dob.value = dobController.text;

    Get.snackbar(
      "Profile Updated",
      "Your information has been saved successfully",
    );
  }
}
