import 'package:expedia/pages/home/flights/multi_city_page.dart';
import 'package:flutter/material.dart';
import '../home/flights/widgets/flight_tab_bar.dart';
import 'package:expedia/pages/home/flights/OnewayPage/one_way_page.dart';
import 'package:expedia/pages/home/flights/roundtrip/round_trip.dart';

class SearchFlightPage extends StatefulWidget {
  const SearchFlightPage({super.key});

  @override
  State<SearchFlightPage> createState() => _SearchFlightPageState();
}

class _SearchFlightPageState extends State<SearchFlightPage> {
  int _flightIndex = 0;

  final List<Widget> _flightPages = [
    RoundtripPage(),
    const OneWayPage(),
    const MultiCityPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Flights")),
      body: SafeArea(
        child: Column(
          children: [
            FlightTabBar(
              selectedIndex: _flightIndex,
              onChanged: (index) {
                setState(() {
                  _flightIndex = index;
                });
              },
            ),
            const Divider(height: 1),

            Expanded(child: _flightPages[_flightIndex]),
          ],
        ),
      ),
    );
  }
}
