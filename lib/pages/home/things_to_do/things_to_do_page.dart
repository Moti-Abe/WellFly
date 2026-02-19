import 'package:flutter/material.dart';
import 'widgets/things_text_field.dart';
import 'widgets/things_date_field.dart';
import 'widgets/activity_card.dart';

class ThingsToDoPage extends StatefulWidget {
  const ThingsToDoPage({super.key});

  @override
  State<ThingsToDoPage> createState() => _ThingsToDoPageState();
}

class _ThingsToDoPageState extends State<ThingsToDoPage> {
  final _formKey = GlobalKey<FormState>();
  final goingToController = TextEditingController();
  final startDateController = TextEditingController();

  // Sample activities data (use local assets to avoid network failures)
  final List<Map<String, String>> activities = [
  
    {
      'title': 'Colosseum Night Tour',
      'subtitle': 'Rome',
      'imageUrl': 'assets/images/shop1.webp',
      'price': '\$50',
    },
    {
      'title': 'Sagrada Familia Guided Tour',
      'subtitle': 'Barcelona',
      'imageUrl': 'assets/images/shop2.jpg',
      'price': '\$40',
    },
  ];

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      controller.text = picked.toString().split(" ")[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ThingsTextField(
              label: "Going to",
              icon: Icons.location_on,
              controller: goingToController,
              validator: (v) => v!.isEmpty ? "Enter destination" : null,
            ),
            ThingsDateField(
              label: "Dates",
              controller: startDateController,
              onTap: () => _pickDate(startDateController),
            ),
            // Removed the separate "To" field; using a single "Dates" field
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Searching activities...')),
                    );
                  }
                },
                child: const Text(
                  "Search",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Popular Activities",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ActivityCard(
                  title: activity['title']!,
                  subtitle: activity['subtitle']!,
                  imageUrl: activity['imageUrl']!,
                  price: activity['price']!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    goingToController.dispose();
    startDateController.dispose();
    super.dispose();
  }
}
