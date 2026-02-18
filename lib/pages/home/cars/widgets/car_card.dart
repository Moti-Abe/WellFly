import 'package:flutter/material.dart';
import '../car_data.dart';

class CarCard extends StatelessWidget {
  final CarModel car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Car image ──
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 170,
              width: double.infinity,
              color: isDark ? const Color(0xFF1A2030) : Colors.grey.shade100,
              child: _buildCarImage(isDark),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Type badge + supplier ──
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1A2340)
                            : const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        car.type,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFF7FB5FF)
                              : const Color(0xFF1565C0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      car.supplier,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ── Car name ──
                Text(
                  car.name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),

                // ── Short description ──
                Text(
                  car.shortDescription,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 10),

                // ── Features row ──
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: car.features.map((f) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 14,
                          color: isDark
                              ? const Color(0xFF66BB6A)
                              : const Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          f,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // ── Price + rating row ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Rating
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1A2340)
                            : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: isDark
                                ? const Color(0xFFFFD54F)
                                : const Color(0xFFFFA000),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            car.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${car.reviewCount} reviews)',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const Spacer(),

                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${car.pricePerDay.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                        ),
                        Text(
                          'per day',
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarImage(bool isDark) {
    // Car type → icon mapping for placeholder
    final iconMap = <String, IconData>{
      'Economy': Icons.directions_car,
      'Compact': Icons.directions_car,
      'Midsize': Icons.directions_car_filled,
      'SUV': Icons.directions_car_filled,
      'Luxury': Icons.directions_car_filled,
      'Convertible': Icons.directions_car,
    };

    final icon = iconMap[car.type] ?? Icons.directions_car;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 72,
            color: isDark
                ? const Color(0xFF7FB5FF).withValues(alpha: 0.7)
                : Colors.blueGrey.shade300,
          ),
          const SizedBox(height: 6),
          Text(
            car.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white38 : Colors.blueGrey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
