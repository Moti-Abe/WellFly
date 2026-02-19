import 'package:flutter/material.dart';

/// Vertical column of travel destination image cards displayed
/// below the search button on Stays and Flights pages.
class TravelImageSection extends StatelessWidget {
  const TravelImageSection({super.key});

  static const List<_ImageItem> _items = [
    _ImageItem(
      asset: 'assets/images/dubai.jpg',
      title: 'Explore Dubai',
      subtitle: 'Luxury stays & stunning views',
    ),
    _ImageItem(
      asset: 'assets/images/shop1.webp',
      title: 'Top Shops',
      subtitle: 'Best local markets & boutiques',
    ),
    _ImageItem(
      asset: 'assets/images/shop2.jpg',
      title: 'Street Markets',
      subtitle: 'Discover hidden gems around the world',
    ),
    _ImageItem(
      asset: 'assets/images/shop3.jpeg',
      title: 'City Life',
      subtitle: 'Urban adventures await you',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Text(
          'Explore destinations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Get inspired for your next trip',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(_items.length, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: i < _items.length - 1 ? 16 : 0),
            child: _TravelImageCard(item: _items[i]),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ─── Data ──────────────────────────────────────────────────────────

class _ImageItem {
  final String asset;
  final String title;
  final String subtitle;

  const _ImageItem({
    required this.asset,
    required this.title,
    required this.subtitle,
  });
}

// ─── Card ──────────────────────────────────────────────────────────

class _TravelImageCard extends StatelessWidget {
  final _ImageItem item;

  const _TravelImageCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Image
            Image.asset(
              item.asset,
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 190,
                color: isDark ? const Color(0xFF1E2433) : Colors.grey.shade200,
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: isDark ? Colors.white24 : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            // Gradient overlay for text legibility
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.55),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),
            // Title overlay
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 6, color: Colors.black38)],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.9),
                      shadows: const [
                        Shadow(blurRadius: 4, color: Colors.black26),
                      ],
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
