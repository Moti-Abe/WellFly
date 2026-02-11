import 'package:flutter/material.dart';

class CarSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Car Rental Search')),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text('Car Rental Search', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.place_outlined),
              hintText: 'Pick-up Location',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: 'Pick-up Date',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: 'Drop-off Date',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, child: Text('Search Button')),
        ],
      ),
    );
  }
}
