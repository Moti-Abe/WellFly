import 'package:expedia/pages/home/auth/auth_controller.dart';
import 'package:expedia/pages/home/cars/cars_page.dart';
import 'package:expedia/pages/home/flights/flights_home.dart';
import 'package:expedia/pages/home/package/packages_page.dart';
import 'package:expedia/pages/home/stays/stays_home.dart';
import 'package:expedia/pages/home/things_to_do/things_to_do_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/top_tab_bar.dart';

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
    CarPage(),
    PackagesPage(),
    ThingsToDoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = isDark ? const Color(0xFF0B0F1A) : Colors.white;

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark
            ? const Color(0xFF0B0F1A)
            : Colors.white.withValues(alpha: 0.95),
        surfaceTintColor: Colors.transparent,
        titleSpacing: 16,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'WellFly',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Get.find<AuthController>().logout();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 18,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            label: Text(
              'Sign Out',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10.0),
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
