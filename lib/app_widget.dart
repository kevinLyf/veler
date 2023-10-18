import 'package:flutter/material.dart';
import 'package:veler/features/screens/splash/splash_screen.dart';
import 'package:veler/shared/themes/dark_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veler',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      darkTheme: darkTheme,
      home: const SplashScreen(),
    );
  }
}