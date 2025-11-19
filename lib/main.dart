import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart'; 
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'utils/colors.dart';
import 'package:coffeapp/screens/cart_screen.dart'; 
import 'package:coffeapp/models/coffe.dart'; 
import 'package:coffeapp/screens/profile_screen.dart'; 
import 'package:coffeapp/utils/page_3d_wrapper.dart';

void main() {
  runApp(const CoffeeApp());
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Vibe',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.darkBg,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.primary,
          background: AppColors.darkBg,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',

      routes: {
        '/': (context) => const Page3DWrapper(child: SplashScreen()),
        '/login': (context) => const Page3DWrapper(child: LoginScreen()),
        '/register': (context) => const Page3DWrapper(child: RegisterScreen()), 
        '/home': (context) => const Page3DWrapper(child: HomeScreen()),
        '/cart': (context) => const Page3DWrapper(child: CartScreen()), 
        '/profile': (context) => const Page3DWrapper(child: ProfileScreen()), 
      },

      onGenerateRoute: (settings) {
        Widget page;
        if (settings.name == '/detail') {
          page = DetailScreen(coffee: dummyCoffeeList[0]);
        } 
        else {
          page = const Scaffold(body: Center(child: Text('Halaman tidak ditemukan')));
        }

        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => Page3DWrapper(child: page),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    );
  }
}