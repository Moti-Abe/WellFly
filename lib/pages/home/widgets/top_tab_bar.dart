import 'package:flutter/material.dart';

class TopTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const TopTabBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const SizedBox(width: 6),
            _TabItem(
              icon: Icons.hotel,
              label: "Stays",
              index: 0,
              selectedIndex: selectedIndex,
              onChanged: onChanged,
            ),
            const SizedBox(width: 8),
            _TabItem(
              icon: Icons.flight,
              label: "Flights",
              index: 1,
              selectedIndex: selectedIndex,
              onChanged: onChanged,
            ),
            const SizedBox(width: 8),
            _TabItem(
              icon: Icons.directions_car,
              label: "Cars",
              index: 2,
              selectedIndex: selectedIndex,
              onChanged: onChanged,
            ),
            const SizedBox(width: 8),
            _TabItem(
              icon: Icons.card_travel,
              label: "Packages",
              index: 3,
              selectedIndex: selectedIndex,
              onChanged: onChanged,
            ),
            const SizedBox(width: 8),
            _TabItem(
              icon: Icons.wb_sunny,
              label: "Things to do",
              index: 4,
              selectedIndex: selectedIndex,
              onChanged: onChanged,
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onChanged;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(index),
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 96,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue.withOpacity(0.12)
                      : Colors.grey.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.blue : Colors.grey[600],
                  size: 28,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              if (isSelected)
                Container(height: 3, width: 40, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
