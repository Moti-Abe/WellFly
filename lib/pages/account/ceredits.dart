import 'package:flutter/material.dart';

class Ceredits extends StatefulWidget {
  const Ceredits({super.key});

  @override
  State<Ceredits> createState() => _CereditsState();
}

class _CereditsState extends State<Ceredits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ceredits")),
      body: Center(child: Text("Ceredits page")),
    );
  }
}
