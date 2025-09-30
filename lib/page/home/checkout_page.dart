import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/cart_service.dart';
import 'package:cafeproject/database/data/order_data.dart';
import 'package:cafeproject/database/auth/navigation_helper.dart';
import 'package:cafeproject/database/auth/auth_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _payment = 'card';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
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
                    Text('Điền thông tin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    SizedBox(height: 16),
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                        SizedBox(width: 24),
                        Column(
                          children: [
                            Radio<String>(
                              value: 'other',
                              groupValue: _payment,
                              onChanged: (v) => setState(() => _payment = v ?? 'other'),
                              visualDensity: VisualDensity.compact,
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.pink[300],
                              ),
                              child: Icon(Icons.add, size: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.trim().isEmpty ||
                        _phoneController.text.trim().isEmpty ||
                        _addressController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Vui lòng điền đủ thông tin')), 
                      );
                      return;
                    }
                    // Tạo đơn hàng với userId
                    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
                    final userId = AuthService.instance.currentUser?.email ?? 'guest';
                    
                    final orderItems = CartService.items.map((cartItem) => OrderItem(
                      productId: cartItem.product.id,
                      productName: cartItem.product.name,
                      price: cartItem.product.price,
                      quantity: cartItem.quantity,
                      size: cartItem.selectedSize,
                    )).toList();
                    
                    final totalAmount = CartService.totalPrice;
                    
                    final order = Order(
                      id: orderId,
                      userId: userId,
                      customerName: _nameController.text.trim(),
                      customerPhone: _phoneController.text.trim(),
                      deliveryAddress: _addressController.text.trim(),
                      items: orderItems,
                      totalAmount: totalAmount,
                      status: 'Chờ xác nhận',
                      createdAt: DateTime.now(),
                    );
                    
                    OrderData.addOrder(order);
                    await CartService.clear();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => NavigationHelper.getHomePage()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDC586D),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Mua', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


