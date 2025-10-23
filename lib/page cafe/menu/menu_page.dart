import 'package:flutter/material.dart';
import 'package:cafeproject/page%20cafe/menu/category_products_page.dart';
import 'package:cafeproject/page%20cafe/home/item.dart';
import 'package:cafeproject/database/data/product_data.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with WidgetsBindingObserver {
  List<Product> allProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadProducts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadProducts();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh products when returning to this page
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await ProductData.loadFromFile();
    setState(() {
      allProducts = ProductData.getAllProducts();
      isLoading = false;
    });
  }
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

          // All products section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tất cả sản phẩm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${allProducts.length} món',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await _loadProducts();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đã cập nhật danh sách sản phẩm'),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          child: Icon(
                            Icons.refresh,
                            color: Color(0xFFDC586D),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (isLoading)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDC586D)),
                      ),
                    ),
                  )
                else if (allProducts.isEmpty)
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Chưa có sản phẩm nào',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...allProducts.map((product) => item1(productId: product.id)).toList(),
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
    final categoryCount = allProducts.where((product) => product.category == title).length;
    
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
            SizedBox(height: 2),
            Text(
              '$categoryCount món',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
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