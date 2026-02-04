// import 'package:flutter/material.dart';

// class YourTripCard extends StatelessWidget {
//   final String from;
//   final String to;
//   final String depart;
//   final String ret;
//   final String travelers;
//   final String cabin;

//   const YourTripCard({
//     super.key,
//     required this.from,
//     required this.to,
//     required this.depart,
//     required this.ret,
//     required this.travelers,
//     required this.cabin,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(top: 12),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Your Trip",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text("From: $from"),
//             Text("To: $to"),
//             Text("Depart: $depart"),
//             Text("Return: $ret"),
//             Text("$travelers • $cabin"),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class YourTripCard extends StatefulWidget {
  final String from;
  final String to;
  final String depart;
  final String ret;

  const YourTripCard({
    super.key,
    required this.from,
    required this.to,
    required this.depart,
    required this.ret,
  });

  @override
  State<YourTripCard> createState() => _YourTripCardState();
}

class _YourTripCardState extends State<YourTripCard> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage("assets/images/dubai.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Share icon
          Positioned(
            top: 10,
            right: 10,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),

          // Like icon
          Positioned(
            top: 10,
            left: 10,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    liked = !liked;
                  });
                },
              ),
            ),
          ),

          // Bottom info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dubai • Emirates",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    "${widget.depart} - ${widget.ret}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "${widget.from} → ${widget.to}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
