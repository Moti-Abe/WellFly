import 'package:flutter/material.dart';

class AccountTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget expandedContent;

  const AccountTile({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.expandedContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: isSelected ? Colors.blue : Colors.transparent,
            child: Row(
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.black),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: isSelected ? const EdgeInsets.all(16) : EdgeInsets.zero,
          color: Colors.blue.shade50,
          child: isSelected ? expandedContent : null,
        ),

        const Divider(height: 1),
      ],
    );
  }
}
