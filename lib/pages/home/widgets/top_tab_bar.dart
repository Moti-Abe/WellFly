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
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TabItem(
            icon: Icons.hotel,
            label: "Stays",
            index: 0,
            selectedIndex: selectedIndex,
            onChanged: onChanged,
          ),
          _TabItem(
            icon: Icons.flight,
            label: "Flights",
            index: 1,
            selectedIndex: selectedIndex,
            onChanged: onChanged,
          ),
          _TabItem(
            icon: Icons.directions_car,
            label: "Cars",
            index: 2,
            selectedIndex: selectedIndex,
            onChanged: onChanged,
          ),
          _TabItem(
            icon: Icons.card_travel,
            label: "Packages",
            index: 3,
            selectedIndex: selectedIndex,
            onChanged: onChanged,
          ),
        ],
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

    return InkWell(
      onTap: () => onChanged(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected) Container(height: 3, width: 40, color: Colors.blue),
        ],
      ),
    );
  }
}
