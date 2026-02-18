import 'package:flutter/material.dart';

/// Hardcoded list of popular pick-up / drop-off locations.
const _locations = [
  _Location('Houston, TX', 'George Bush Intercontinental Airport (IAH)'),
  _Location('Houston, TX', 'William P. Hobby Airport (HOU)'),
  _Location('New York, NY', 'John F. Kennedy International Airport (JFK)'),
  _Location('New York, NY', 'LaGuardia Airport (LGA)'),
  _Location('Los Angeles, CA', 'Los Angeles International Airport (LAX)'),
  _Location('London, UK', 'Heathrow Airport (LHR)'),
  _Location('London, UK', 'Gatwick Airport (LGW)'),
  _Location('Dubai, UAE', 'Dubai International Airport (DXB)'),
  _Location('Paris, France', 'Charles de Gaulle Airport (CDG)'),
  _Location('Tokyo, Japan', 'Haneda Airport (HND)'),
  _Location('Istanbul, Turkey', 'Istanbul Airport (IST)'),
  _Location('Addis Ababa, Ethiopia', 'Bole International Airport (ADD)'),
  _Location('Nairobi, Kenya', 'Jomo Kenyatta Airport (NBO)'),
  _Location('Cairo, Egypt', 'Cairo International Airport (CAI)'),
  _Location('Mumbai, India', 'Chhatrapati Shivaji Airport (BOM)'),
];

class _Location {
  final String city;
  final String detail;
  const _Location(this.city, this.detail);
}

/// Full-screen location search for the Cars page.
class CarLocationSearchScreen extends StatefulWidget {
  final String title;

  const CarLocationSearchScreen({super.key, required this.title});

  @override
  State<CarLocationSearchScreen> createState() =>
      _CarLocationSearchScreenState();
}

class _CarLocationSearchScreenState extends State<CarLocationSearchScreen> {
  final _searchController = TextEditingController();
  List<_Location> _filtered = List.from(_locations);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = List.from(_locations);
      } else {
        final q = query.toLowerCase();
        _filtered = _locations
            .where(
              (l) =>
                  l.city.toLowerCase().contains(q) ||
                  l.detail.toLowerCase().contains(q),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: 'Search by city or airport',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(color: colors.onSurface),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: _filtered.length,
              separatorBuilder: (context2, index2) => Divider(
                height: 1,
                indent: 56,
                color: colors.outline.withValues(alpha: 0.2),
              ),
              itemBuilder: (context, index) {
                final loc = _filtered[index];
                return ListTile(
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                  title: Text(
                    loc.city,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    loc.detail,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  onTap: () => Navigator.pop(context, loc.city),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
