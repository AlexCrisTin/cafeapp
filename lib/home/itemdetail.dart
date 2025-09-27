import 'package:flutter/material.dart';
import 'package:cafeproject/data/product_data.dart';
import 'package:cafeproject/data/cart_service.dart';

class ItemDetailPage extends StatefulWidget {
  final Product product;
  
  const ItemDetailPage({super.key, required this.product});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  String? selectedSize;

  double _getCurrentPrice() {
    if (selectedSize != null && widget.product.hasSize) {
      return widget.product.getPriceForSize(selectedSize!);
    }
    return widget.product.price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sản phẩm'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent),
                color: Colors.grey[200],
                image: widget.product.imagePath.trim().isNotEmpty
                    ? DecorationImage(
                        image: AssetImage(widget.product.imagePath),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: widget.product.imagePath.trim().isNotEmpty
                  ? null
                  : Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
            ),
            SizedBox(height: 20),
            Text(
              widget.product.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.product.category,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.product.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            // Size selection for drinks
            if (widget.product.hasSize) ...[
              Text(
                'Chọn size:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: ['S', 'M', 'L'].map((size) {
                  final price = widget.product.getPriceForSize(size);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSize = size;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: selectedSize == size ? Colors.red : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedSize == size ? Colors.red : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              size,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: selectedSize == size ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              '${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                              style: TextStyle(
                                fontSize: 12,
                                color: selectedSize == size ? Colors.white : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
            ],
            Row(
              children: [
                Text(
                  'Giá: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_getCurrentPrice().toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VNĐ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.product.hasSize && selectedSize == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Vui lòng chọn size!')),
                    );
                    return;
                  }
                  CartService.addToCart(widget.product, selectedSize: selectedSize);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã thêm ${widget.product.name}${selectedSize != null ? ' ($selectedSize)' : ''} vào giỏ hàng!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Thêm vào giỏ hàng',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}