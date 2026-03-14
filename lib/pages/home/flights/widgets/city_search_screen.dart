import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/flight_controller.dart';
import '../../../../data/models/airport_model.dart';

class CitySearchScreen extends StatefulWidget {
  final String title;
  const CitySearchScreen({super.key, required this.title});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final FlightController _controller = Get.find<FlightController>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clear previous results when entering
    _controller.searchResultsAirports.assignAll([]);
    _controller.currentSearchQuery.value = '';
  }

  void _runFilter(String query) {
    _controller.searchAirports(query);
  }

  void _selectAirport(AirportModel airport) {
    _controller.airportService.addRecentSearch(airport);
    Navigator.pop(context, airport.displayName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _runFilter('');
                          setState(() {});
                        },
                      )
                    : null,
                hintText: "City or Airport Code",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final query = _controller.currentSearchQuery.value;

              if (query.isEmpty || query.length < 3) {
                return _buildEmptyState();
              }

              if (_controller.isSearchingAirports.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final airports = _controller.searchResultsAirports;
              if (airports.isEmpty) {
                return const Center(
                  child: Text(
                    "No airports found",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                itemCount: airports.length,
                itemBuilder: (context, index) {
                  final airport = airports[index];
                  return _buildAirportTile(airport);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAirportTile(AirportModel airport) {
    return ListTile(
      leading: const Icon(Icons.flight_takeoff, color: Colors.grey),
      title: Text(airport.displayName),
      subtitle: Text(airport.country),
      onTap: () => _selectAirport(airport),
    );
  }

  Widget _buildEmptyState() {
    final recent = _controller.airportService.recentSearches;
    final popular = _controller.airportService.popularAirports;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        if (_searchController.text.isNotEmpty && _searchController.text.length < 3)
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              "Please enter at least 3 characters to search",
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        if (recent.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recent Searches", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(
                onPressed: () => _controller.airportService.clearRecentSearches(),
                child: const Text("Clear"),
              )
            ],
          ),
          const SizedBox(height: 8),
          ...recent.map((a) => _buildAirportTile(a)),
          const Divider(),
        ],
        if (popular.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Popular Airports", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ...popular.map((a) => _buildAirportTile(a)),
        ]
      ],
    );
  }
}
