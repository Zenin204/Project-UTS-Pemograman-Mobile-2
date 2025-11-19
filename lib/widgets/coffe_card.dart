import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffeapp/utils/colors.dart';

// Mengubah CoffeeCard menjadi StatefulWidget
class CoffeeCard extends StatefulWidget {
  final String title;
  final double price; // Pastikan ini double sesuai perbaikan sebelumnya
  final String imageUrl;
  final String heroTag;
  final VoidCallback onTap;
  final VoidCallback onAddTap;

  const CoffeeCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.heroTag,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  State<CoffeeCard> createState() => _CoffeeCardState();
}

class _CoffeeCardState extends State<CoffeeCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationX;
  late Animation<double> _rotationY;
  late Animation<double> _scale;
  late Animation<double> _translationZ;

  Offset _mousePosition = Offset.zero; // Posisi mouse relatif terhadap kartu
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Animasi rotasi X (vertical tilt)
    _rotationX = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    // Animasi rotasi Y (horizontal tilt)
    _rotationY = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    // Animasi skala (membesar sedikit)
    _scale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    // Animasi translasi Z (melayang ke depan)
    _translationZ = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool hover) {
    setState(() {
      _isHovering = hover;
    });
    if (hover) {
      _animationController.forward();
    } else {
      _animationController.reverse();
      // Reset mouse position saat tidak hover
      setState(() {
        _mousePosition = Offset.zero; 
      });
    }
  }

  // Fungsi untuk menghitung rotasi berdasarkan posisi mouse
  void _updateRotation(PointerEvent details) {
    if (!_isHovering) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(details.position);

    final double width = renderBox.size.width;
    final double height = renderBox.size.height;

    // Normalisasi posisi mouse dari -1.0 hingga 1.0
    // (0,0) adalah tengah kartu
    final double normalizedX = (localPosition.dx / width) * 2 - 1; 
    final double normalizedY = (localPosition.dy / height) * 2 - 1;

    // Atur mousePosition untuk digunakan dalam AnimatedBuilder
    setState(() {
      _mousePosition = Offset(normalizedX, normalizedY);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion( // Mendeteksi mouse masuk/keluar dan pergerakan
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      onHover: _updateRotation, // Update posisi mouse saat kursor bergerak di atas kartu
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animationController, // Animasi untuk scale dan translation
          builder: (context, child) {
            // Rotasi berdasarkan posisi mouse, diperhalus oleh animasi controller
            final double tiltX = _rotationX.value * _mousePosition.dy; // mouse ke bawah -> rotasi ke atas
            final double tiltY = _rotationY.value * -_mousePosition.dx; // mouse ke kanan -> rotasi ke kiri

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0008) // Efek perspektif yang sedikit lebih kuat
                ..rotateX(tiltX) 
                ..rotateY(tiltY)
                ..translate(0.0, 0.0, _translationZ.value) // Mendorong kartu ke depan
                ..scale(_scale.value), // Memperbesar kartu sedikit
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _isHovering // Efek bayangan yang lebih dinamis saat hover
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.6),
                            blurRadius: 25,
                            spreadRadius: 3,
                            offset: Offset(_mousePosition.dx * 10, _mousePosition.dy * 10), // Bayangan mengikuti arah mouse
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Hero(
                        tag: widget.heroTag,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(widget.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.price.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        InkWell(
                          onTap: widget.onAddTap,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}