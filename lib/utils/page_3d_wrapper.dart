import 'dart:math';
import 'package:flutter/material.dart';

class Page3DWrapper extends StatefulWidget {
  final Widget child;
  const Page3DWrapper({super.key, required this.child});

  @override
  State<Page3DWrapper> createState() => _Page3DWrapperState();
}

class _Page3DWrapperState extends State<Page3DWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateX;
  late Animation<double> _opacity;
  late Animation<double> _slideY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Durasi animasi
    );

    // Animasi Opacity (Fade in): dari 0.0 -> 1.0
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animasi Rotasi 3D (Tilt): dari 30 derajat -> 0 derajat
    // (pi / 6 radian adalah 30 derajat)
    _rotateX = Tween<double>(begin: pi / 6, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // Animasi Slide (Geser ke atas): dari 50 pixel di bawah -> 0
    _slideY = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // Mulai animasi saat halaman dibuka
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform(
            // Terapkan semua transformasi 3D
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Efek Perspektif
              ..rotateX(_rotateX.value) // Rotasi 3D
              ..translate(0.0, _slideY.value), // Geser Y
            child: widget.child,
          ),
        );
      },
    );
  }
}