import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/social_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In ")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SocialButton(
              text: "Sign in with Google",
              asset: "assets/images/google.png",
              onPressed: () {},
            ),

            const SizedBox(height: 20),
            const Center(child: Text("or")),

            const SizedBox(height: 20),

            Form(
              key: _formKey,
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter email";
                  }
                  if (!GetUtils.isEmail(value)) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    debugPrint("Email: ${emailController.text}");
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Center(child: Text("Other ways to sign in")),

            const SizedBox(height: 16),

            SocialButton(
              text: "Sign in with Facebook",
              asset: "assets/images/facebook.png",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
