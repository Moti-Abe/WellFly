import 'package:expedia/pages/home/flights/multi-city/multi_city.dart';
import 'package:expedia/pages/home/flights/one_way.dart';
import 'package:expedia/pages/home/flights/round_trip.dart';
import 'package:flutter/material.dart';
import 'widgets/flight_tab_bar.dart';

class FlightsPage extends StatefulWidget {
  const FlightsPage({super.key});

  @override
  State<FlightsPage> createState() => _FlightsPageState();
}

class _FlightsPageState extends State<FlightsPage> {
  int _flightIndex = 0;

  final List<Widget> _flightPages = const [
    RoundtripPage(),
    OneWayPage(),
    MultiCityPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
