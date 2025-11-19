import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffeapp/utils/colors.dart'; 
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:flutter/gestures.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String _validEmail = 'user@coffee.com';
  final String _validPassword = '123456';

  bool _isPasswordVisible = false;

  void _login() {
    if (_emailController.text == _validEmail &&
        _passwordController.text == _validPassword) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Email atau Password salah. Coba lagi.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = _validEmail;
    _passwordController.text = _validPassword;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg, 
      body: Stack(
        fit: StackFit.expand,
        children: [
          // --- LAPISAN 1: GAMBAR LATAR (MARMER/BETON) ---
          Image.asset(
            'assets/images/premium_cafe_bg.png', 
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: AppColors.darkBg),
          ),

          // --- LAPISAN 2: EFEK VIGNETTE ---
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

          // --- LAPISAN 3: KOTAK LOGIN SOLID ---
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
                      'Selamat datang kembali!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 40),

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
                    const SizedBox(height: 40),

                    _buildLoginButton(),
                    
                    const SizedBox(height: 20),
                    
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Tidak punya akun? ',
                          style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Buat akun',
                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                             
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                
                                  Navigator.of(context).pushReplacementNamed('/register');
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false, 
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      style: GoogleFonts.poppins(color: AppColors.textLight), 
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: AppColors.textGrey),
        prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
        
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textGrey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
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

  Widget _buildLoginButton() {
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
        onPressed: _login, 
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, 
          shadowColor: Colors.transparent, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Login',
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