import 'package:flutter/material.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Offers & Recommendations")),
      body: Center(child: Text("Offers settings here")),
    );
  }
}
