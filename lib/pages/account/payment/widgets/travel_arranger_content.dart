import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelArrangerContent extends StatefulWidget {
  const TravelArrangerContent({super.key});

  @override
  State<TravelArrangerContent> createState() => _TravelArrangerContentState();
}

class _TravelArrangerContentState extends State<TravelArrangerContent> {
  bool showForm = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Expedia travel arranger lets you book travel for your friends or co-workers.",
        ),

        const SizedBox(height: 16),

        ElevatedButton(
          onPressed: () {
            setState(() {
              showForm = true;
            });
          },
          child: const Text("Add New Traveler"),
        ),

        if (showForm) ...[
          const SizedBox(height: 16),

          Form(
            key: formKey,
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Traveler Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),

              validator: (v) {
                if (v!.isEmpty) return "Enter email";
                if (!v.contains("@")) return "Invalid email";
                return null;
              },
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Get.snackbar(
                        "Success",
                        "Traveler added: ${emailController.text}",
                      );
                      emailController.clear();
                      setState(() {
                        showForm = false;
                      });
                    }
                  },
                  child: const Text("Submit"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      showForm = false;
                    });
                  },
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
