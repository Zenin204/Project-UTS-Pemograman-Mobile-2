import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffeapp/utils/colors.dart';
import 'package:coffeapp/models/user_model.dart';
import 'package:animate_do/animate_do.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Fungsi untuk dialog Logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text('Logout', style: GoogleFonts.poppins(color: AppColors.textLight)),
        content: Text('Anda yakin ingin keluar dari akun Anda?', style: GoogleFonts.poppins(color: AppColors.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal', style: GoogleFonts.poppins(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // Kembali ke halaman Login
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: Text('Logout', style: GoogleFonts.poppins(color: AppColors.textLight)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text('My Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textGrey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- 1. BAGIAN HEADER PROFIL (DENGAN ANIMASI) ---
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.cardBg,
                    backgroundImage: AssetImage(dummyUser.profileImage),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    dummyUser.name, 
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    dummyUser.email, 
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- 2. BAGIAN MENU (DENGAN ANIMASI) ---
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 100),
              child: _buildProfileItem(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {},
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 200),
              child: _buildProfileItem(
                icon: Icons.local_offer_outlined,
                title: 'My Vouchers',
                onTap: () {},
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 300),
              child: _buildProfileItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {},
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 400),
              child: _buildProfileItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {},
              ),
            ),
            const Divider(color: AppColors.cardBg, height: 40),
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 500),
              child: _buildProfileItem(
                icon: Icons.logout,
                title: 'Logout',
                color: Colors.red[400]!,
                onTap: () => _showLogoutDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = AppColors.textGrey,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textGrey, size: 16),
        onTap: onTap,
      ),
    );
  }
}