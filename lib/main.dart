import 'package:expedia/pages/home/auth/auth_controller.dart';
import 'package:expedia/pages/home/auth/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/account/controllers/setting_controller.dart';

import 'package:expedia/data/services/api_service.dart';
import 'package:expedia/data/services/airport_service.dart';
import 'package:expedia/pages/home/flights/controllers/flight_controller.dart';

import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => ApiService().init());
  await Get.putAsync(() => AirportSearchService().init());
  Get.put(FlightController());
  Get.put(AuthController());
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final settingsController = Get.put(SettingsController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF0B0F1A),
            foregroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
        ),
        themeMode: settingsController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const SignInPage(),
      ),
    );
  }
}
