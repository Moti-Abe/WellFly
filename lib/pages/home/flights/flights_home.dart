import 'package:expedia/pages/home/flights/multi_city_page.dart';
import 'package:expedia/pages/home/flights/OnewayPage/one_way_page.dart';
import 'package:expedia/pages/home/flights/roundtrip/round_trip.dart';
import 'package:flutter/material.dart';
import 'widgets/flight_tab_bar.dart';

class FlightsPage extends StatefulWidget {
  const FlightsPage({super.key});

  @override
  State<FlightsPage> createState() => _FlightsPageState();
}

class _FlightsPageState extends State<FlightsPage> {
  int _flightIndex = 0;

  final List<Widget> _flightPages = [
    RoundtripPage(),
    const OneWayPage(),
    const MultiCityPage(),
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
