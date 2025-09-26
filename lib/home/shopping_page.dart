import 'package:flutter/material.dart';
import 'package:cafeproject/data/cart_service.dart';
import 'package:cafeproject/home/checkout_page.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: CartService.items.isEmpty
                  ? Center(child: Text('Giỏ hàng trống'))
                  : ListView.separated(
                      itemCount: CartService.items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = CartService.items[index];
                        return _buildCartItem(item);
                      },
                    ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng cộng:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatPrice(CartService.totalPrice),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDC586D),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (CartService.items.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Giỏ hàng trống')),
                          );
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CheckoutPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFDC586D),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        'Thanh toán',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final intValue = price.toInt();
    final formatted = intValue
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return '$formatted VNĐ';
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Icon(Icons.coffee, color: Colors.brown, size: 30),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatPrice(item.product.price),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFDC586D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  CartService.decreaseQuantity(item.product.id);
                  _refresh();
                },
                icon: Icon(Icons.remove_circle_outline),
                color: Colors.grey,
              ),
              Text('${item.quantity}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () {
                  CartService.increaseQuantity(item.product.id);
                  _refresh();
                },
                icon: Icon(Icons.add_circle_outline),
                color: Color(0xFFDC586D),
              ),
              IconButton(
                onPressed: () {
                  CartService.removeFromCart(item.product.id);
                  _refresh();
                },
                icon: Icon(Icons.delete_outline),
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
