import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_growth_plus/ui/auth/login_intro_screen.dart';
import 'package:kids_growth_plus/ui/auth/signup_screen.dart';
import 'package:kids_growth_plus/ui/widget/square_tile.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';

class SignupIntroScreen extends StatelessWidget {
  const SignupIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                // Image Section
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/one_doctor.png', // Replace with your local asset path
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  height: 380,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B3B7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),  // Different radius for top-left
                      topRight: Radius.circular(40.0), // Different radius for top-right
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        Text(
                          "Daftar sekarang!",
                          style: GoogleFonts.poppins(  // Apply Poppins font
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF002247),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          "Dan dapatkan akses penuh secara gratis mengenai stunting dan perkembangan pada anak.",
                          style: GoogleFonts.poppins(  // Apply Poppins font
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF002247),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignupScreen()),
                            );
                            print('Daftar Akun clicked!');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 9.0),
                          ),
                          child: Center(
                            child: Text(
                              "Buat Akun",
                              style: GoogleFonts.nunitoSans(  // Apply Poppins font
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF002247),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            children: [
                              // First Line (Divider or Container with height)
                              Expanded(
                                child: Divider(
                                  color: Colors.white,  // Line color
                                  thickness: 1,  // Line thickness
                                ),
                              ),
        
                              // Text in the middle
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Atau masuk dengan',
                                  style: GoogleFonts.nunitoSans(  // Apply Poppins font
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
        
                              // Second Line (Divider or Container with height)
                              Expanded(
                                child: Divider(
                                  color: Colors.white,  // Line color
                                  thickness: 1,  // Line thickness
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    await Provider.of<AuthProvider>(context, listen: false).signInWithGoogle(context);
                                    // Define your action here
                                    print('Google Button clicked!');
                                  },
                                  child: SquareTile(imagePath: 'assets/google.png')
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            // First Line (Divider or Container with height)
                            Spacer(),
        
                            // Text in the middle
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 13,
                                    color: Colors.white,  // Default text color
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Sudah punya akun? ',  // Regular text
                                      style: TextStyle(color: Colors.white),  // Style for this part
                                    ),
                                    TextSpan(
                                      text: 'Masuk disini',  // Underlined part
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,  // Apply underline
                                        color: Colors.white,  // You can change color here if needed
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => const LoginIntroScreen()),
                                          );
                                          // Action on tap (you can replace this with your desired action)
                                          print('Masuk disini clicked!');
                                          // You can navigate to another screen or show a dialog
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
        
                            Spacer()
                          ],
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Logo Section
            Positioned(
              top: 10,
              left: 16,
              child: SvgPicture.asset(
                'assets/logo_color.svg',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
