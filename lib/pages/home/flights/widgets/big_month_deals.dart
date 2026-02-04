// import 'package:flutter/material.dart';

// class BigMonthDeals extends StatelessWidget {
//   const BigMonthDeals({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(top: 20),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               "Big Month Deals",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             ListTile(
//               leading: Icon(Icons.local_offer),
//               title: Text("January Deals"),
//               subtitle: Text("Save up to 25%"),
//             ),
//             ListTile(
//               leading: Icon(Icons.local_offer),
//               title: Text("February Deals"),
//               subtitle: Text("Save up to 20%"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class BigMonthDeals extends StatelessWidget {
  const BigMonthDeals({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF00355F), Color.fromARGB(255, 12, 33, 54)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Big Month Deals",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 6),
          const Text(
            "Save up to 25% on flights",
            style: TextStyle(color: Colors.white70),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Book now →",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
