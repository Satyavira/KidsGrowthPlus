import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kids_growth_plus/ui/main/add_child_data_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../services/firestore_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isFormValid = false;
  bool isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool validateForm() {
    String phone = _phoneController.text.trim();
    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (phone.isEmpty || phone.length < 10) {
      showError("Phone number is invalid");
      return false;
    }

    if (fullName.isEmpty) {
      showError("Full name is required");
      return false;
    }

    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      showError("Please enter a valid email address");
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      showError("Password must be at least 6 characters");
      return false;
    }

    return true;
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 4),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo Section
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SvgPicture.asset(
                        'assets/logo_color.svg',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Phone Number Field
                  const Text("Phone Number"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Country Code
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/indonesia_circle.svg',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 5,),
                          const Text(
                            "+62",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF767676),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      // Phone Number Input
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            hintText: "Enter your phone number",
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Full Name Field
                  const Text("Full Name"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      hintText: "Enter your full name",
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Email Field
                  const Text("Email"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "Enter your email",
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  const Text("Password"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: "Enter your password",
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
          ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (validateForm()) {
                        String phone = _phoneController.text;
                        String fullName = _fullNameController.text;
                        String email = _emailController.text;
                        String password = _passwordController.text;

                        try {
                          await authProvider.signUp(email.trim(), password.trim());
                          FirestoreService firestoreService =
                          FirestoreService();
                          await firestoreService.storeUserData(
                              fullName.trim(), phone.trim(), email.trim());

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Verification email sent! Please check your inbox."),
                              duration: Duration(seconds: 4),
                            ),
                          );

                          authProvider.startEmailVerificationCheck(() {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => AddChildDataScreen()),
                                  (Route<dynamic> route) => false,
                            );
                          });
                        } catch (e) {
                          showError("Failed to sign up: ${e.toString()}");
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002247),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "Buat Akun",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
