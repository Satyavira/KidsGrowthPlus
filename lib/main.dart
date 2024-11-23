import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kids_growth_plus/firebase_options.dart';
import 'package:kids_growth_plus/provider/auth_provider.dart';
import 'package:kids_growth_plus/ui/onboard/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ChangeNotifierProvider(
          create: (BuildContext context) => AuthProvider(),
          child: const KidsGrowthApp()
      )
  );
}

class KidsGrowthApp extends StatelessWidget {
  const KidsGrowthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KidsGrowth+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}