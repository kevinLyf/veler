import 'dart:async';

import 'package:flutter/material.dart';
import 'package:veler/features/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? timer;

  @override
  void initState() {
    timerInit();

    super.initState();
  }

  @override
  void dispose() {
    if(!mounted) return;
    if(timer != null) timer!.cancel();
    super.dispose();
  }

  void timerInit() {
    timer = Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset("./public/assets/icons/logo.png"),
          ),
          const SizedBox(height: 40),
          const CircularProgressIndicator(color: Colors.white)
        ],
      ),
    );
  }
}
