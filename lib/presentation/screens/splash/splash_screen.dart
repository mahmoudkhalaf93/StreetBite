import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/app_colors.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  void _startSplashSequence() {
    // Start fade-in animation slightly later so the engine is fully ready to render it
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    // Wait for animation to finish, then navigate based on Auth State
    Future.delayed(const Duration(milliseconds: 3000), () {
      _checkAuthAndNavigate();
    });
  }

  void _checkAuthAndNavigate() {
    if (!mounted) return;

    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, navigate to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // User is not logged in, navigate to Login / Onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for responsiveness (adapts to mobile and tablets)
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.primary, // Using centralized AppColors instead of hardcoded hex
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 2), // 2 seconds fade-in animation
          curve: Curves.easeIn,
          opacity: _opacity,
          child: SvgPicture.asset(
            'assets/images/app logo.svg',
            width: size.width * 0.5, // 50% of the screen width for responsive sizing
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

