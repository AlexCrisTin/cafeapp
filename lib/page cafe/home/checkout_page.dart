import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/cart_service.dart';
import 'package:cafeproject/database/data/orders_service.dart';
import 'package:cafeproject/database/data/default_address_service.dart';
import 'package:cafeproject/database/auth/auth_service.dart';
import 'package:cafeproject/database/auth/navigation_helper.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final AuthService _auth = AuthService.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();

  String _payment = 'card';
  String _addressOption = 'new'; // 'new' or 'default'
  Map<String, String>? _defaultAddress;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDefaultAddress();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cardNumberController.dispose();
    _cardCvvController.dispose();
    _cardExpiryController.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultAddress() async {
    final userId = _auth.currentUser?.email;
    if (userId != null) {
      final address = await DefaultAddressService.getDefaultAddress(userId);
      if (address != null) {
        setState(() {
          _defaultAddress = address;
          _addressOption = 'default';
          _nameController.text = address['name'] ?? '';
          _phoneController.text = address['phone'] ?? '';
          _addressController.text = address['address'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Thông tin'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFDC586D), width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thông tin giao hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    SizedBox(height: 16),
                    
                    // Address option selection
                    if (_defaultAddress != null) ...[
                      Text('Chọn địa chỉ giao hàng', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              value: 'default',
                              groupValue: _addressOption,
                              onChanged: (value) {
                                setState(() {
                                  _addressOption = value!;
                                  _nameController.text = _defaultAddress!['name'] ?? '';
                                  _phoneController.text = _defaultAddress!['phone'] ?? '';
                                  _addressController.text = _defaultAddress!['address'] ?? '';
                                });
                              },
                              title: Text('Địa chỉ mặc định', style: TextStyle(fontSize: 14)),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              value: 'new',
                              groupValue: _addressOption,
                              onChanged: (value) {
                                setState(() {
                                  _addressOption = value!;
                                  _nameController.clear();
                                  _phoneController.clear();
                                  _addressController.clear();
                                });
                              },
                              title: Text('Địa chỉ mới', style: TextStyle(fontSize: 14)),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                    
                    Text('Thông tin người nhận', style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Họ và tên',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Số điện thoại',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Địa chỉ',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(child: Text('Cách thức thanh toán', style: TextStyle(fontWeight: FontWeight.w600))),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Radio<String>(
                              value: 'card',
                              groupValue: _payment,
                              onChanged: (v) => setState(() => _payment = v ?? 'card'),
                              visualDensity: VisualDensity.compact,
                            ),
                            Container(
                              width: 48,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.blue[200],
                              ),
                              child: Icon(Icons.credit_card, size: 18, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(width: 24),
                        Column(
                          children: [
                            Radio<String>(
                              value: 'cash',
                              groupValue: _payment,
                              onChanged: (v) => setState(() => _payment = v ?? 'cash'),
                              visualDensity: VisualDensity.compact,
                            ),
                            Container(
                              width: 48,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.green[300],
                              ),
                              child: Icon(Icons.attach_money, size: 18, color: Colors.white),
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                    AnimatedSize(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: _payment == 'card'
                          ? Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Thông tin thẻ', style: TextStyle(fontWeight: FontWeight.w600)),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: _cardNumberController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Số thẻ (16 số)',
                                      prefixIcon: Icon(Icons.credit_card),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _cardCvvController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: 'CVV/CVC',
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: _cardExpiryController,
                                          keyboardType: TextInputType.datetime,
                                          decoration: InputDecoration(
                                            hintText: 'MM/YY',
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    if (_nameController.text.trim().isEmpty ||
                        _phoneController.text.trim().isEmpty ||
                        _addressController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Vui lòng điền đủ thông tin')), 
                      );
                      return;
                    }
                    if (_payment == 'card') {
                      final cardNumber = _cardNumberController.text.replaceAll(' ', '');
                      final cvv = _cardCvvController.text.trim();
                      final expiry = _cardExpiryController.text.trim();
                      if (cardNumber.isEmpty || cvv.isEmpty || expiry.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Vui lòng nhập đủ thông tin thẻ')),
                        );
                        return;
                      }
                      if (cardNumber.length < 13 || cardNumber.length > 19) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Số thẻ không hợp lệ')),
                        );
                        return;
                      }
                      if (cvv.length < 3 || cvv.length > 4) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('CVV/CVC không hợp lệ')),
                        );
                        return;
                      }
                      if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(expiry)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ngày hết hạn không hợp lệ (MM/YY)')),
                        );
                        return;
                      }
                    }
                    
                    setState(() => _isLoading = true);
                    
                    try {
                      // Tạo đơn hàng
                      await OrdersService.createOrder(
                        name: _nameController.text.trim(),
                        phone: _phoneController.text.trim(),
                        address: _addressController.text.trim(),
                        payment: _payment,
                        cartItems: CartService.items,
                      );
                      await CartService.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => NavigationHelper.getHomePage()),
                        (route) => false,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Có lỗi xảy ra khi tạo đơn hàng')),
                      );
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDC586D),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('Mua', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}


