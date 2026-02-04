import 'package:flutter/material.dart';
import 'search_one_way.dart';
import 'search_multi_city.dart';
import 'search_round_trip.dart';
import '../../home/flights/widgets/flight_tab_bar.dart';

class SearchFlightPage extends StatefulWidget {
  const SearchFlightPage({super.key});

  @override
  State<SearchFlightPage> createState() => _SearchFlightPageState();
}

class _SearchFlightPageState extends State<SearchFlightPage> {
  int _flightIndex = 0;

  final List<Widget> _flightPages = const [
    RoundtripSearchPage(),
    OneWaySearchPage(),
    MultiCitySearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
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
