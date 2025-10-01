import 'package:flutter/material.dart';
import 'package:cafeproject/data/data/cart_service.dart';
import 'package:cafeproject/page%20cafe/home/checkout_page.dart';
import 'package:cafeproject/data/img/image_upload.dart';

class UserCart extends StatefulWidget {
  const UserCart({super.key});

  @override
  State<UserCart> createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
        actions: [
          if (CartService.items.isNotEmpty)
            TextButton(
              onPressed: () {
                CartService.clear();
                setState(() {});
              },
              child: Text(
                'Xóa tất cả',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: CartService.items.isEmpty
          ? _buildEmptyCart()
          : _buildCartContent(),
      bottomNavigationBar: CartService.items.isNotEmpty
          ? _buildCheckoutBar()
          : null,
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'Giỏ hàng trống',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Hãy thêm sản phẩm vào giỏ hàng',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.shopping_bag),
            label: Text('Tiếp tục mua sắm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFDC586D),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: CartService.items.length,
            itemBuilder: (context, index) {
              final cartItem = CartService.items[index];
              final product = cartItem.product;
              
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Product Image
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: ImageHelper.buildDecorationImage(product.imagePath),
                        ),
                      ),
                      SizedBox(width: 12),
                      
                      // Product Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Builder(
                              builder: (_) {
                                final String? size = cartItem.selectedSize;
                                final double unitPrice = (size != null && product.hasSize)
                                    ? product.getPriceForSize(size)
                                    : product.price;
                                return Text(
                                  '${unitPrice.toStringAsFixed(0)} VNĐ',
                                  style: TextStyle(
                                    color: Color(0xFFDC586D),
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                            if (product.hasSize) ...[
                              SizedBox(height: 1),
                              Row(
                                children: [
                                  Text(
                                    'Size:',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  SizedBox(width: 8),
                                  DropdownButton<String>(
                                    value: cartItem.selectedSize,
                                    hint: Text('Chọn size'),
                                    items: (product.sizePrices?.keys.toList() ?? const <String>[]) 
                                        .map((sz) => DropdownMenuItem<String>(
                                              value: sz,
                                              child: Text(sz),
                                            ))
                                        .toList(),
                                    onChanged: (val) async {
                                      if (val == null) return;
                                      await CartService.setItemSize(product.id, val);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      // Quantity Controls
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                CartService.decreaseQuantity(cartItem.product.id);
                              });
                            },
                            icon: Icon(Icons.remove_circle_outline),
                            color: Colors.red,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${cartItem.quantity}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                CartService.increaseQuantity(cartItem.product.id);
                              });
                            },
                            icon: Icon(Icons.add_circle_outline),
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutBar() {
    final total = CartService.totalPrice;
    final itemCount = CartService.totalQuantity;
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng cộng ($itemCount sản phẩm)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${total.toStringAsFixed(0)} VNĐ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC586D),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => CheckoutPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFDC586D),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Thanh toán',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
