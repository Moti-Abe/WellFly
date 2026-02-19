import 'package:expedia/pages/home/auth/auth_controller.dart';
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
  final passwordController = TextEditingController();

  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBg = isDark ? const Color(0xFF0B0F1A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF151A24) : Colors.grey.shade50;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade300;
    final accentColor = isDark ? const Color(0xFF7FB5FF) : Colors.blue;

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Logo area
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.flight, size: 40, color: accentColor),
              ),
              const SizedBox(height: 20),

              Text(
                'Welcome to wellfly',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 15,
                  color: colors.onSurface.withValues(alpha: 0.6),
                ),
              ),

              const SizedBox(height: 32),

              // Social buttons
              SocialButton(
                text: 'Sign in with Google',
                asset: 'assets/images/google.png',
                backgroundColor: isDark
                    ? const Color(0xFF1E2433)
                    : Colors.white,
                textColor: colors.onSurface,
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              SocialButton(
                text: 'Sign in with Facebook',
                asset: 'assets/images/facebook.png',
                backgroundColor: const Color(0xFF1877F2),
                textColor: Colors.white,
                onPressed: () {},
              ),

              const SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: borderColor)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'or sign in with email',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: borderColor)),
                ],
              ),

              const SizedBox(height: 24),

              // Form card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email field
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: colors.onSurface),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: colors.onSurface.withValues(alpha: 0.6),
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: accentColor,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF0B0F1A)
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: accentColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!GetUtils.isEmail(value.trim())) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Password field
                      Obx(
                        () => TextFormField(
                          controller: passwordController,
                          obscureText: authController.obscureText.value,
                          style: TextStyle(color: colors.onSurface),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: '••••••',
                            labelStyle: TextStyle(
                              color: colors.onSurface.withValues(alpha: 0.6),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: accentColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                authController.obscureText.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: colors.onSurface.withValues(alpha: 0.5),
                              ),
                              onPressed: authController.toggleVisibility,
                            ),
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF0B0F1A)
                                : Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: accentColor,
                                width: 1.5,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sign In button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              authController.login(
                                email: emailController.text.trim(),
                                password: passwordController.text,
                              );
                            }
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Hint text
              Text.rich(
                TextSpan(
                  text: 'Try: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.onSurface.withValues(alpha: 0.4),
                  ),
                  children: [
                    TextSpan(
                      text: 'test@example.com',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const TextSpan(text: ' / '),
                    TextSpan(
                      text: '123456',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
