import 'package:flutter/material.dart';
import 'multi-city/pages/multi_city_search_page.dart';

class MultiCityPage extends StatefulWidget {
  const MultiCityPage({super.key});

  @override
  State<MultiCityPage> createState() => _MultiCityPageState();
}

class _MultiCityPageState extends State<MultiCityPage> {
  @override
  Widget build(BuildContext context) {
    return const MultiCitySearchPage();
  }
}
