import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffeapp/utils/colors.dart';
import 'package:coffeapp/models/cart_item.dart';
import 'package:animate_do/animate_do.dart';
import 'package:coffeapp/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  void _onCartUpdated() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    globalCart.addListener(_onCartUpdated);
  }

  @override
  void dispose() {
    globalCart.removeListener(_onCartUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = globalCart.value;
    double total = calculateTotalPrice();

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text('My Cart', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textGrey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          if (cart.isEmpty)
            Center(
              child: FadeIn(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 100, color: AppColors.cardBg),
                    const SizedBox(height: 20),
                    Text(
                      'Keranjang Anda Kosong',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight),
                    ),
                    Text(
                      'Ayo tambahkan kopi favoritmu!',
                      style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
            ),

          if (cart.isNotEmpty)
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 150),
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return FadeInLeft(
                  delay: Duration(milliseconds: 100 * index),
                  duration: const Duration(milliseconds: 400),
                  child: _buildCartItemCard(item),
                );
              },
            ),
        ],
      ),

      bottomNavigationBar: cart.isEmpty ? null : SlideInUp(
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -5),
              )
            ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Price', style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 14)),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        imageUrl: cart.first.coffee.imageUrl,
                        title: '${cart.length} items',
                        price: total,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textLight,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                ),
                child: Text(
                  'Checkout',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item.coffee.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.coffee.title,
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textLight),
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${item.coffee.price.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: AppColors.textGrey),
                onPressed: () {
                  removeFromCart(item); 
                },
              ),
              Text(
                '${item.quantity}',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textLight),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                onPressed: () {
                  addToCart(item.coffee);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}