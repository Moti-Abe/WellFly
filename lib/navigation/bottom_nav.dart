import 'package:flutter/material.dart';
import '../pages/home/home_page.dart';
import '../pages/search/search_page.dart';
import '../pages/trips/trips_page.dart';
import '../pages/inbox/inbox_page.dart';
import '../pages/account/account_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    SearchPage(),
    TripsPage(),
    InboxPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: "Trips",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "Inbox"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
