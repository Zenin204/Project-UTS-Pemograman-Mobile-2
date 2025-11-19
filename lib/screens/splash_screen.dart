import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffeapp/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacementNamed('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold adalah kerangka dasar halaman
    return Scaffold(
      backgroundColor: AppColors.darkBg, 
      body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Coffee',
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight, 
            ),
            children: [
              TextSpan(
                text: 'Vibe',
                style: GoogleFonts.dancingScript( 
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}