import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/product_data.dart';
import 'package:cafeproject/page%20cafe/home/itemdetail.dart';

class CategoryProductsPage extends StatelessWidget {
  final String category;

  const CategoryProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = ProductData.getProductsByCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh mục: $category'),
      ),
      body: products.isEmpty
          ? const Center(child: Text('Không có sản phẩm'))
          : ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                  title: Text(product.name),
                  subtitle: Text(product.category),
                  trailing: Text('${product.price.toStringAsFixed(0)} đ'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ItemDetailPage(product: product),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}


