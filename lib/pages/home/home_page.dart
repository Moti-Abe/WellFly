import 'package:expedia/pages/home/auth/sign_in_page.dart';
import 'package:expedia/pages/home/cars/cars_page.dart';
import 'package:expedia/pages/home/flights/flights_home.dart';
import 'package:expedia/pages/home/package/packages_page.dart';
import 'package:expedia/pages/home/stays/stays_home.dart';
import 'package:flutter/material.dart';
import 'widgets/top_tab_bar.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    StaysPage(),
    FlightsPage(),
    CarsPage(),
    PackagesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(40, 247, 178, 1),
        title: Row(
          children: [
            Image.asset("assets/images/expedia_logo.png", height: 40),
            // Expanded(child: Text("Flight App")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => const SignInPage());
            },
            child: Text("Sign In"),
          ),
        ],
      ),
      body: Column(
        children: [
          TopTabBar(
            selectedIndex: _selectedIndex,
            onChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          const Divider(height: 1),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
