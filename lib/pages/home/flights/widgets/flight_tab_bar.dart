// import 'package:flutter/material.dart';

// class FlightTabBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onChanged;

//   const FlightTabBar({
//     super.key,
//     required this.selectedIndex,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Flights")),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _TabItem(
//                 label: "Roundtrip",
//                 index: 0,
//                 selectedIndex: selectedIndex,
//                 onChanged: onChanged,
//               ),
//               _TabItem(
//                 label: "One-way",
//                 index: 1,
//                 selectedIndex: selectedIndex,
//                 onChanged: onChanged,
//               ),
//               _TabItem(
//                 label: "Multi-city",
//                 index: 2,
//                 selectedIndex: selectedIndex,
//                 onChanged: onChanged,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _TabItem extends StatelessWidget {
//   final String label;
//   final int index;
//   final int selectedIndex;
//   final Function(int) onChanged;

//   const _TabItem({
//     required this.label,
//     required this.index,
//     required this.selectedIndex,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isSelected = index == selectedIndex;

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () => onChanged(index),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? Colors.blue : Colors.grey,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//             const SizedBox(height: 4),
//             if (isSelected) Container(height: 3, width: 40, color: Colors.blue),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class FlightTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const FlightTabBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TabItem(
            label: "Roundtrip",
            index: 0,
            selectedIndex: selectedIndex,
            onChanged: onChanged,
          ),
          _TabItem(
            label: "One-way",
            index: 1,
            selectedIndex: selectedIndex,
            onChanged: onChanged,
          ),
          _TabItem(
            label: "Multi-city",
            index: 2,
            selectedIndex: selectedIndex,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onChanged;

  const _TabItem({
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(index),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              if (isSelected)
                Container(height: 3, width: 40, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
