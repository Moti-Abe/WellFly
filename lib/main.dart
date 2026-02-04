import 'package:flutter/material.dart';
import 'navigation/bottom_nav.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: BottomNav(),
    );
  }
}
