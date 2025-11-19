import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffeapp/utils/colors.dart'; 
import 'package:coffeapp/widgets/size_selector.dart';
import 'package:coffeapp/models/coffe.dart';     
import 'package:coffeapp/models/cart_item.dart';  

class DetailScreen extends StatefulWidget {
  final Coffee coffee;

  const DetailScreen({
    super.key,
    required this.coffee, 
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _selectedSize = 'Medium';
  bool _extraMilk = true;
  bool _lessSugar = false;
  bool _addFlavor = false;
  bool _extraShot = false;
  bool _whippedCream = true;
  bool _almondMilk = false;
  bool _oatMilk = false;
  bool _decaf = false;
  bool _caramelDrizzle = false;
  bool _cinnamonPowder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 400, 
                width: double.infinity,
                child: Hero(
                  tag: widget.coffee.imageUrl, 
                  child: Image.asset( 
                    widget.coffee.imageUrl, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.cardBg,
                        child: const Icon(Icons.coffee, color: AppColors.textGrey, size: 60),
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: 400,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.darkBg.withOpacity(0.8),
                      AppColors.darkBg,
                    ],
                    stops: const [0.5, 0.9, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: 40, 
                left: 10,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.darkBg.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: AppColors.textLight),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.coffee.title, 
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLight,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            '${widget.coffee.rating} (${widget.coffee.reviewCount}+ Reviews)', 
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text('Customizations', style: _sectionTitle()),
                  _buildCheckboxRow('Extra Milk', _extraMilk, (val) => setState(() => _extraMilk = val!)),
                  _buildCheckboxRow('Less Sugar', _lessSugar, (val) => setState(() => _lessSugar = val!)),
                  _buildCheckboxRow('Add Flavor', _addFlavor, (val) => setState(() => _addFlavor = val!)),
                  _buildCheckboxRow('Almond Milk', _almondMilk, (val) => setState(() => _almondMilk = val!)),
                  _buildCheckboxRow('Oat Milk', _oatMilk, (val) => setState(() => _oatMilk = val!)),
                  _buildCheckboxRow('Decaf', _decaf, (val) => setState(() => _decaf = val!)),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.cardBg),
                  Text('Add-Ons', style: _sectionTitle()),
                  _buildCheckboxRow('Extra Shot', _extraShot, (val) => setState(() => _extraShot = val!)),
                  _buildCheckboxRow('Whipped Cream', _whippedCream, (val) => setState(() => _whippedCream = val!)),
                  _buildCheckboxRow('Caramel Drizzle', _caramelDrizzle, (val) => setState(() => _caramelDrizzle = val!)),
                  _buildCheckboxRow('Cinnamon Powder', _cinnamonPowder, (val) => setState(() => _cinnamonPowder = val!)),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.cardBg),
                  Text('Size', style: _sectionTitle()),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizeSelector(
                        label: 'Small',
                        isSelected: _selectedSize == 'Small',
                        onTap: () => setState(() => _selectedSize = 'Small'),
                      ),
                      SizeSelector(
                        label: 'Medium',
                        isSelected: _selectedSize == 'Medium',
                        onTap: () => setState(() => _selectedSize = 'Medium'),
                      ),
                      SizeSelector(
                        label: 'Large',
                        isSelected: _selectedSize == 'Large',
                        onTap: () => setState(() => _selectedSize = 'Large'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.darkBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
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
                Text(
                  'Price',
                  style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 14),
                ),
                Text(
                  '\$${widget.coffee.price.toStringAsFixed(2)}', 
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            ElevatedButton(
              onPressed: () {
                addToCart(widget.coffee); 
                Navigator.pushNamed(context, '/cart');
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: Text(
                'Add to Cart',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _sectionTitle() {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textLight,
    );
  }

  Widget _buildCheckboxRow(String title, bool value, Function(bool?) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 14)),
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          checkColor: AppColors.textLight,
          side: const BorderSide(color: AppColors.primary),
        ),
      ],
    );
  }
}