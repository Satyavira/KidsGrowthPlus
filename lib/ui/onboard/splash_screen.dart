import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kids_growth_plus/styles/colors.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import 'welcome_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green,
      body: Center(
        child: SvgPicture.asset(
          'assets/logo.svg',
          width: 133,
          height: 137,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}