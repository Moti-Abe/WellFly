import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/search_tile.dart';
import './stays_search_page.dart';
import '../home/cars/cars_page.dart';
import '../home/package/packages_page.dart';
import '../search/searchFlight/search_flight_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Smaller 2x2 Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.4, // makes tiles smaller
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SearchTile(
                  title: "Stays",
                  icon: Icons.hotel,
                  onTap: () => Get.to(() => const StaysSearchPage()),
                ),
                SearchTile(
                  title: "Flights",
                  icon: Icons.flight,
                  onTap: () => Get.to(() => const SearchFlightPage()),
                ),
                SearchTile(
                  title: "Cars",
                  icon: Icons.directions_car,
                  onTap: () => Get.to(() => const CarPage()),
                ),
                SearchTile(
                  title: "Packages",
                  icon: Icons.card_travel,
                  onTap: () => Get.to(() => const PackagesPage()),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Deals container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.local_offer, size: 36, color: Colors.blue),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Explore the latest flight deals we found for you",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text("Find deals"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Start searching section
            Center(
              child: Column(
                children: [
                  const Icon(Icons.search, size: 60, color: Colors.blue),
                  const SizedBox(height: 8),
                  const Text(
                    "Start searching",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 180,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                      onPressed: () {},
                      child: const Text("Try again"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
