import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();
  final emailController = TextEditingController();

  void sendFeedback() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        "Thank you!",
        "Your feedback has been sent",
        snackPosition: SnackPosition.BOTTOM,
      );

      commentController.clear();
      emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help and  Feedback")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.help_outline, color: Colors.blue),
                  title: const Text("Visit Help Center"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Get.snackbar(
                      "Help Center",
                      "This would open help center website",
                    );
                  },
                ),
              ),

              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.help_outline, color: Colors.blue),
                  title: const Text("Rate Our App"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Get.snackbar("Rate App", "Thankyou for rating our app ");
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                "Share your feedback",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: commentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Your comment",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter your feedback" : null,
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Your email",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter email";
                  if (!GetUtils.isEmail(v)) return "Invalid email";
                  return null;
                },
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: 500.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: sendFeedback,
                  child: const Text("Send feedback"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
