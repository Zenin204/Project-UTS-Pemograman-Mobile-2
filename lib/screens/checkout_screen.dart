import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffeapp/utils/colors.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';

class CheckoutScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final double price;

  const CheckoutScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Map<String, dynamic>? _selectedVoucher; 
  String _selectedPayment = 'GoPay'; 
  final TextEditingController _pinController = TextEditingController();
  
  final TextEditingController _addressController = TextEditingController();
  
  final List<Map<String, dynamic>> _vouchers = [
    {'code': 'KOPIHEMAT', 'description': 'Diskon Tetap \$1.50', 'value': 1.50},
    {'code': 'NGOPI20', 'description': 'Diskon 20% (Maks \$2.00)', 'value': 2.00},
    {'code': 'GRATISKOPI', 'description': 'Diskon \$0.50', 'value': 0.50},
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'GoPay', 'icon': Icons.account_balance_wallet_outlined},
    {'name': 'OVO', 'icon': Icons.data_usage_rounded}, 
    {'name': 'Dana', 'icon': Icons.monetization_on_outlined}, 
    {'name': 'Credit Card', 'icon': Icons.credit_card},
    {'name': 'Bank Transfer', 'icon': Icons.account_balance},
    {'name': 'Cash on Delivery (COD)', 'icon': Icons.local_shipping_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _addressController.text = 'Jl. Kopi Enak No. 1, Bandung, 40123';
  }

  @override
  void dispose() {
    _addressController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _showVoucherSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pilih Voucher', style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(Icons.cancel_outlined, color: AppColors.textGrey),
                title: Text('Tidak Pakai Voucher', style: GoogleFonts.poppins(color: AppColors.textLight)),
                onTap: () {
                  setState(() {
                    _selectedVoucher = null; 
                  });
                  Navigator.of(context).pop();
                },
              ),
              const Divider(color: AppColors.darkBg),
              ..._vouchers.map((voucher) {
                return ListTile(
                  leading: const Icon(Icons.local_offer, color: AppColors.primary),
                  title: Text(voucher['code'], style: GoogleFonts.poppins(color: AppColors.textLight, fontWeight: FontWeight.w600)),
                  subtitle: Text(voucher['description'], style: GoogleFonts.poppins(color: AppColors.textGrey)),
                  onTap: () {
                    setState(() {
                      _selectedVoucher = voucher;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pilih Metode Pembayaran', style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  final payment = _paymentMethods[index];
                  bool isSelected = _selectedPayment == payment['name'];
                  return ListTile(
                    leading: Icon(payment['icon'], color: isSelected ? AppColors.primary : AppColors.textGrey),
                    title: Text(payment['name'], style: GoogleFonts.poppins(color: isSelected ? AppColors.primary : AppColors.textLight, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                    onTap: () {
                      setState(() {
                        _selectedPayment = payment['name'];
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _showPinDialog() {
    String? dialogError;
    _pinController.clear(); 

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              backgroundColor: AppColors.cardBg,
              title: Center(
                child: Text('Masukan PIN Keamanan', style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Masukan 6 digit PIN $_selectedPayment Anda.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 24, letterSpacing: 8),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '------',
                      hintStyle: GoogleFonts.poppins(color: AppColors.textGrey.withOpacity(0.5), fontSize: 24, letterSpacing: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: AppColors.darkBg,
                    ),
                  ),
                  if (dialogError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            dialogError!,
                            style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Batal', style: GoogleFonts.poppins(color: AppColors.textGrey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () {
                    if (_pinController.text == '123456') { // PIN yang benar
                      Navigator.of(context).pop(); 
                      _showSuccessDialog(); 
                    } else {
                      dialogSetState(() {
                        dialogError = 'Maaf, PIN yang dimasukan salah';
                      });
                      _pinController.clear();
                    }
                  },
                  child: Text('Konfirmasi', style: GoogleFonts.poppins(color: AppColors.textLight)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeIn(
              child: const Icon(Icons.check_circle, color: Colors.green, size: 80),
            ),
            const SizedBox(height: 20),
            Text(
              'Pembayaran Berhasil!',
              style: GoogleFonts.poppins(
                color: AppColors.textLight,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Pesanan Anda sedang kami proses. Terima kasih!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('Tutup', style: GoogleFonts.poppins(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double subtotal = widget.price;
    double diskon = _selectedVoucher != null ? _selectedVoucher!['value'] : 0;
    double total = subtotal - diskon;
    if (total < 0) total = 0; 

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text('Rincian Pesanan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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

            FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: _buildSectionCard(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(widget.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(widget.title, style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    Text('\$${widget.price.toStringAsFixed(2)}', style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),

            FadeInUp(
              duration: const Duration(milliseconds: 400),
              child: _buildSectionCard(
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.primary, size: 30),
                        const SizedBox(width: 10),
                        Text(
                          'Alamat Pengiriman', 
                          style: GoogleFonts.poppins(color: AppColors.textLight, fontWeight: FontWeight.w600, fontSize: 16)
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // TextField untuk alamat
                    TextField(
                      controller: _addressController,
                      style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 14),
                      maxLines: 2, 
                      decoration: InputDecoration(
                        hintText: 'Masukan alamat lengkap Anda...',
                        hintStyle: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 14),
                        filled: true,
                        fillColor: AppColors.darkBg, 
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none, 
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: _buildSectionCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.local_offer, color: AppColors.primary, size: 30),
                  title: Text(
                    _selectedVoucher != null ? _selectedVoucher!['code'] : 'Pilih Voucher', 
                    style: GoogleFonts.poppins(color: AppColors.textLight, fontWeight: FontWeight.w500)
                  ),
                  subtitle: Text(
                    _selectedVoucher != null ? _selectedVoucher!['description'] : 'Dapatkan diskon untuk pesananmu', 
                    style: GoogleFonts.poppins(color: _selectedVoucher != null ? Colors.green : AppColors.textGrey)
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textGrey, size: 16),
                  onTap: _showVoucherSheet, 
                ),
              ),
            ),

            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: _buildSectionCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    _paymentMethods.firstWhere((p) => p['name'] == _selectedPayment)['icon'], 
                    color: AppColors.primary, 
                    size: 30
                  ),
                  title: Text('Metode Pembayaran', style: GoogleFonts.poppins(color: AppColors.textGrey)),
                  subtitle: Text(_selectedPayment, style: GoogleFonts.poppins(color: AppColors.textLight, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textGrey, size: 16),
                  onTap: _showPaymentSheet, 
                ),
              ),
            ),
            
            // 5. Total Harga (Tidak berubah dari sebelumnya)
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              child: _buildSectionCard(
                child: Column(
                  children: [
                    _buildPriceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _selectedVoucher != null ? 30 : 0,
                      child: _selectedVoucher != null
                          ? _buildPriceRow('Diskon (${_selectedVoucher!['code']})', '-\$${diskon.toStringAsFixed(2)}', isDiscount: true)
                          : null,
                    ),
                    const Divider(color: AppColors.cardBg),
                    _buildPriceRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Tombol Buy (Tidak berubah)
      bottomNavigationBar: SlideInUp(
        duration: const Duration(milliseconds: 800),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -5))]
          ),
          child: ElevatedButton(
            onPressed: _showPinDialog, 
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Buy Now',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  // Widget Bantuan
  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildPriceRow(String title, String price, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: isTotal ? AppColors.textLight : AppColors.textGrey,
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: GoogleFonts.poppins(
              color: isDiscount ? Colors.green : (isTotal ? AppColors.primary : AppColors.textLight),
              fontSize: isTotal ? 20 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}