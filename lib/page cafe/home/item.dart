import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/product_data.dart';
import 'package:cafeproject/page%20cafe/home/itemdetail.dart';
import 'package:cafeproject/database/img/image_helper.dart';
import 'package:cafeproject/database/data/cart_service.dart';

class Item extends StatefulWidget {
  const Item({super.key});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      products = ProductData.getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10, left: 10),
          child: Text('Gợi ý cho bạn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        ),
        // Hiển thị 3 sản phẩm đầu tiên
        if (products.isNotEmpty)
          ...products.take(3).map((product) => item1(productId: product.id)).toList()
        else
          Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text('Đang tải sản phẩm...', style: TextStyle(color: Colors.grey[600])),
            ),
          ),
      ],
    );
  }
}
class item1 extends StatefulWidget {
  final String productId;

  const item1({super.key, required this.productId});

  @override
  State<item1> createState() => _item1State();
}

class _item1State extends State<item1> {
  @override
  Widget build(BuildContext context) {
    final product = ProductData.getProductById(widget.productId);
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (product != null) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ItemDetailPage(product: product)),
              );
            } 
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Container(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      image: ImageHelper.buildDecorationImage(product?.imagePath),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product?.name ?? 'Sản phẩm',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          product?.category ?? '',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star_half, color: Colors.amber, size: 16),
                            Icon(Icons.star_border, color: Colors.amber, size: 16),
                            SizedBox(width: 6),
                            Text('3.5', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product != null 
                                ? product.hasSize && product.sizePrices != null && product.sizePrices!.containsKey('S')
                                  ? '${product.sizePrices!['S']!.toStringAsFixed(0)} đ'
                                  : '${product.price.toStringAsFixed(0)} đ'
                                : '',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFDC586D)),
                            ),
                            ElevatedButton.icon(
                              onPressed: product == null ? null : () async {
                                await CartService.addToCart(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Đã thêm vào giỏ hàng')),
                                );
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFDC586D),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              icon: Icon(Icons.add_shopping_cart, size: 18),
                              label: Text('Thêm'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

