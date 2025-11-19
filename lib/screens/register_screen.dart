import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffeapp/utils/colors.dart'; 
import 'package:flutter/foundation.dart' show kIsWeb; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk field baru
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // State untuk ikon mata (terpisah)
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _register() {
    // Logika register sederhana
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty || 
        _confirmPasswordController.text.isEmpty) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Semua field harus diisi!'),
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Password dan Konfirmasi Password tidak cocok!'),
        ),
      );
      return;
    }

    // Jika berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Akun berhasil dibuat! Silakan login.'),
      ),
    );
    
    // Pindah ke halaman login setelah berhasil register
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg, 
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/premium_cafe_bg.png', // Latar belakang yang sama
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: AppColors.darkBg),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0, 
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView( 
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: kIsWeb ? 400 : MediaQuery.of(context).size.width * 0.85, 
                constraints: const BoxConstraints(maxWidth: 400), 
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColors.cardBg, 
                  borderRadius: BorderRadius.circular(24), 
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3), 
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Coffee',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textLight,
                        ),
                        children: [
                          TextSpan(
                            text: 'Vibe',
                            style: GoogleFonts.dancingScript(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary, 
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Buat akun baru Anda', // <-- Teks diubah
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 40),

                    // --- FIELD BARU DITAMBAHKAN ---
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Nama Lengkap',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _emailController,
                      hint: 'Email',
                      icon: Icons.alternate_email,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hint: 'Konfirmasi Password',
                      icon: Icons.check_circle_outline,
                      isPassword: true,
                      isConfirm: true, 
                    ),
                    
                    const SizedBox(height: 40),
                    _buildRegisterButton(),
                    
                    const SizedBox(height: 20),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Sudah punya akun? ',
                          style: GoogleFonts.poppins(color: AppColors.textGrey),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushReplacementNamed('/login');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget helper untuk TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false, 
    bool isConfirm = false,
  }) {
    bool isVisible = isConfirm ? _isConfirmPasswordVisible : _isPasswordVisible;

    return TextField(
      controller: controller,
      obscureText: isPassword ? !isVisible : false,
      style: GoogleFonts.poppins(color: AppColors.textLight), 
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: AppColors.textGrey),
        prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
        
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textGrey,
                ),
                onPressed: () {
                  setState(() {
                    if (isConfirm) {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    } else {
                      _isPasswordVisible = !_isPasswordVisible;
                    }
                  });
                },
              )
            : null,
            
        filled: true,
        fillColor: AppColors.darkBg, 
        border: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, 
        ),
      ),
      keyboardType: hint == 'Email' ? TextInputType.emailAddress : TextInputType.visiblePassword,
    );
  }

  /// Widget helper untuk Tombol Register
  Widget _buildRegisterButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary, 
            AppColors.secondary.withOpacity(0.8), 
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, 
          shadowColor: Colors.transparent, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Buat Akun',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark, 
          ),
        ),
      ),
    );
  }
}