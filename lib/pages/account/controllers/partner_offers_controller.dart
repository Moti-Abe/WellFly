import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PartnerOffersController extends GetxController {
  final push = false.obs;
  final email = false.obs;
  final sms = false.obs;

  final countryCodes = ["+251", "+44", "+91"];
  final countryCode = "+251".obs;

  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void updateCommunication() {
    if (sms.value) {
      if (!formKey.currentState!.validate()) {
        return;
      }
    }
    Get.snackbar(
      "Success",
      "Communication updated",
      snackPosition: SnackPosition.BOTTOM,
    );

    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
