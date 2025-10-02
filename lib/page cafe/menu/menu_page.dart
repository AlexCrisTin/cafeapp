import 'package:flutter/material.dart';
import 'package:cafeproject/page%20cafe/menu/category_products_page.dart';
import 'package:cafeproject/page%20cafe/home/item.dart';
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          

          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Danh mục',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryButton(
                        icon: Icons.coffee,
                        title: 'Cafe',
                        color: Color(0xFF8D6E63),
                        onTap: () => _navigateToCategory('Cafe'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildCategoryButton(
                        icon: Icons.local_drink,
                        title: 'Trà sữa',
                        color: Color(0xFFE91E63),
                        onTap: () => _navigateToCategory('Trà sữa'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildCategoryButton(
                        icon: Icons.local_drink,
                        title: 'Trà',
                        color: Color(0xFF4CAF50),
                        onTap: () => _navigateToCategory('Trà'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryButton(
                        icon: Icons.cake,
                        title: 'Đồ ăn ngọt',
                        color: Color(0xFFFF9800),
                        onTap: () => _navigateToCategory('Đồ ăn ngọt'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildCategoryButton(
                        icon: Icons.restaurant,
                        title: 'Đồ ăn mặn',
                        color: Color(0xFF795548),
                        onTap: () => _navigateToCategory('Đồ ăn mặn'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 25),

          // Recommended products
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gợi ý cho bạn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Xem tất cả',
                        style: TextStyle(
                          color: Color(0xFFDC586D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                item1(productId: '1'),
                item1(productId: '2'),
                item1(productId: '3'),
                item1(productId: '4'),
                item1(productId: '5'),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryProductsPage(category: category),
      ),
    );
  }
}