import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffeapp/utils/colors.dart'; 
import 'package:coffeapp/models/coffe.dart'; 
import 'package:coffeapp/widgets/category_chip.dart';
import 'package:coffeapp/widgets/coffe_card.dart'; 
import 'package:coffeapp/screens/detail_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:coffeapp/models/cart_item.dart'; 
import 'package:coffeapp/widgets/shop_card.dart';
import 'package:coffeapp/models/user_model.dart'; 
// --- 1. IMPORT WRAPPER 3D ---
import 'package:coffeapp/utils/page_3d_wrapper.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Hot Coffee';
  final List<String> _categories = [
    'Hot Coffee',
    'Iced Coffee',
    'Frappuccino',
    'Mocha',
    'Latte'
  ];
  int _hoverIndex = -1; 

  final List<Map<String, dynamic>> _nearbyShops = [
    {
      'name': 'Coffeinopia JKT',
      'image': 'assets/images/shop_1.jpeg', 
      'rating': 4.9,
      'distance': '1.4km'
    },
    {
      'name': 'Kopi Senja',
      'image': 'assets/images/shop_2.jpg', 
      'rating': 4.8,
      'distance': '2.1km'
    },
    {
      'name': 'The Daily Grind',
      'image': 'assets/images/shop_3.jpg', 
      'rating': 4.7,
      'distance': '3.5km'
    },
    {
      'name': 'Brew & Bloom',
      'image': 'assets/images/shop_4.png', 
      'rating': 4.9,
      'distance': '4.0km'
    },
    {
      'name': 'Aroma Kopi',
      'image': 'assets/images/shop_5.png', 
      'rating': 4.6,
      'distance': '5.2km'
    },
  ];

  void _onItemTapped(int index) {
    if (index == 3) { 
      Navigator.pushNamed(context, '/cart');
    } else if (index == 4) { 
      Navigator.pushNamed(context, '/profile');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  // --- 2. FUNGSI NAVIGASI DETAIL DIPERBARUI ---
  void _navigateToDetail(Coffee coffee) {
    Navigator.of(context).push(
      // Kita tidak pakai MaterialPageRoute lagi
      PageRouteBuilder(
        // Bungkus DetailScreen dengan Page3DWrapper
        pageBuilder: (context, animation, secondaryAnimation) => Page3DWrapper(
          child: DetailScreen(coffee: coffee),
        ),
        // Gunakan FadeTransition agar tidak bentrok
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300), // Durasi fade
      ),
    );
  }
  // --- BATAS PERBARUAN ---


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: _buildHeader(),
              ),
              FadeInLeft(
                duration: const Duration(milliseconds: 500),
                child: _buildPromoCard(), 
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 24),
              _buildCategories(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildProductGrid(), 
              ),
              
              const SizedBox(height: 24),
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                delay: const Duration(milliseconds: 400),
                child: _buildNearbyShopsSection(),
              ),
              const SizedBox(height: 20), 
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage:
                    AssetImage(dummyUser.profileImage), 
                onBackgroundImageError: (e, s) {},
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '☕ Halo, ${dummyUser.name}!', 
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    'Siap nikmati kopi hari ini?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.notifications_none, color: AppColors.textGrey),
        ],
      ),
    );
  }

  // --- 3. KARTU PROMO DIPERBARUI DENGAN 3D ---
  Widget _buildPromoCard() {
    const String promoTitle = "🔥 Coffee Festival Week!";
    const String promoSubtitle = "Diskon hingga 20% untuk minuman favoritmu!";

    return Transform( 
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Perspektif
        ..rotateX(0.02) // Rotasi ringan pada sumbu X
        ..rotateY(-0.02), // Rotasi ringan pada sumbu Y
      child: Container(
        width: double.infinity,
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: const AssetImage('assets/images/promo_banner.jpg'),
            fit: BoxFit.cover,
            colorFilter:
                ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
            onError: (e, s) {},
          ),
          boxShadow: [ // Bayangan untuk efek 3D
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              promoTitle,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
                shadows: [
                  Shadow(
                      blurRadius: 10, color: Colors.black.withOpacity(0.5))
                ],
              ),
            ),
            Text(
              promoSubtitle,
              style: GoogleFonts.poppins(
                color: AppColors.textLight.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Pesan Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
  // --- BATAS PERBARUAN ---

  Widget _buildSearchBar() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      delay: const Duration(milliseconds: 200),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari kopi favoritmu...',
          hintStyle: TextStyle(color: AppColors.textGrey),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.filter_list, color: AppColors.primary),
          ),
          filled: true,
          fillColor: AppColors.cardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      delay: const Duration(milliseconds: 300),
      child: SizedBox(
        height: 45,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return CategoryChip(
              label: _categories[index],
              isSelected: _categories[index] == _selectedCategory,
              onTap: () => _onCategorySelected(_categories[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNearbyShopsSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Shop',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
              Row(
                children: [
                  Text(
                    'See All',
                    style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, color: AppColors.primary, size: 16),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 220, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _nearbyShops.length,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final shop = _nearbyShops[index];
              return FadeInLeft(
                delay: Duration(milliseconds: 100 * index),
                duration: const Duration(milliseconds: 400),
                child: ShopCard(
                  name: shop['name'],
                  imageUrl: shop['image'],
                  rating: shop['rating'],
                  distance: shop['distance'],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid() { 
    
    final filteredList = dummyCoffeeList
        .where((coffee) => coffee.category == _selectedCategory)
        .toList(); 

    double width = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (width < 600) {
      crossAxisCount = 2;
    } else if (width < 1000) {
      crossAxisCount = 3; 
    } else {
      crossAxisCount = 4; 
    }

    if (filteredList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Tidak ada produk di kategori "$_selectedCategory"',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 16),
          ),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: GridView.builder(
        key: ValueKey<String>(_selectedCategory), 
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75, 
        ),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final coffee = filteredList[index];
          return FadeInUp(
            delay: Duration(milliseconds: 100 * index),
            duration: const Duration(milliseconds: 300),
            child: CoffeeCard( 
              title: coffee.title,
              price: coffee.price,
              imageUrl: coffee.imageUrl,
              heroTag: coffee.imageUrl,
              onTap: () => _navigateToDetail(coffee),
              onAddTap: () => _navigateToDetail(coffee),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return SlideInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        height: 70, 
        decoration: BoxDecoration(
          color: AppColors.darkBg, 
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: ValueListenableBuilder(
          valueListenable: globalCart,
          builder: (context, List<CartItem> cart, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined, 
                  activeIcon: Icons.home_filled, 
                  label: 'Home', 
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.favorite_border,
                  activeIcon: Icons.favorite,
                  label: 'Favorite', 
                  index: 1,
                ),
                _buildCenterButton(), 
                _buildNavItem(
                  icon: Icons.shopping_cart_outlined, 
                  activeIcon: Icons.shopping_cart,
                  label: 'Cart', 
                  index: 3, 
                  cartCount: cart.length,
                ),
                _buildNavItem(
                  icon: Icons.person_outline, 
                  activeIcon: Icons.person,
                  label: 'Profile', 
                  index: 4,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    final bool isHovered = _hoverIndex == 2;
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoverIndex = 2),
        onExit: (_) => setState(() => _hoverIndex = -1),
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: () => _onItemTapped(2),
          borderRadius: BorderRadius.circular(50), 
          child: AnimatedScale( 
            scale: isHovered ? 1.15 : 1.0, 
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary, 
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    int cartCount = 0,
  }) {
    final bool isSelected = _selectedIndex == index;
    final bool isHovered = _hoverIndex == index;
    final Color color = isSelected ? AppColors.primary : AppColors.textGrey;

    Widget iconWidget = Icon(
      isSelected ? activeIcon : icon, 
      color: color, 
      size: 28
    );
    if (label == 'Cart' && cartCount > 0) {
      iconWidget = Badge(
        label: Text('$cartCount'),
        isLabelVisible: true,
        backgroundColor: AppColors.primary,
        child: iconWidget,
      );
    }

    return Expanded(
      child: MouseRegion( 
        onEnter: (_) => setState(() => _hoverIndex = index),
        onExit: (_) => setState(() => _hoverIndex = -1),
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          borderRadius: BorderRadius.circular(20), 
          child: AnimatedScale( 
            scale: isHovered ? 1.15 : 1.0, 
            duration: const Duration(milliseconds: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconWidget,
                const SizedBox(height: 5), 
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 3,
                  width: isSelected ? 20 : 0, 
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}