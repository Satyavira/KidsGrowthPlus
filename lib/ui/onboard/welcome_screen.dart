import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kids_growth_plus/ui/auth/login_intro_screen.dart';
import 'package:kids_growth_plus/ui/main/add_child_data_screen.dart';
import 'package:kids_growth_plus/ui/main/child_profile_screen.dart';
import '../../styles/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10), // Margin atas
                  SvgPicture.asset(
                    'assets/logo_color.svg',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Selamat datang di KidsGrowth+!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Aplikasi yang akan memantau setiap langkah pertumbuhan anak. '
                        'Dengan KidsGrowth+, pantau perkembangan anak, dapatkan tips stunting, dan gizi.',
                    style: TextStyle(
                      fontSize: 16,
                      color: darkBlue, // Replaced with darkBlue variable
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginIntroScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Warna tombol remains the same
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // Color remains the same
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/two_doctor.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
