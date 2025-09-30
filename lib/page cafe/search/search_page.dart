import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/product_data.dart';
import 'package:cafeproject/page%20cafe/home/itemdetail.dart';
import 'package:cafeproject/database/img/image_helper.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Product> _results = ProductData.getAllProducts();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    final String q = _controller.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() {
        _results = ProductData.getAllProducts();
      });
      return;
    }
    setState(() {
      _results = ProductData.products.where((p) {
        final name = p.name.toLowerCase();
        final cat = p.category.toLowerCase();
        return name.contains(q) || cat.contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Người đẹp muốn uống gì',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                          },
                        ),
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: _results.isEmpty
                    ? Center(child: Text('Không tìm thấy sản phẩm'))
                    : ListView.separated(
                        itemCount: _results.length,
                        separatorBuilder: (_, __) => Divider(height: 1),
                        itemBuilder: (context, index) {
                          final product = _results[index];
                          return ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.redAccent),
                                color: Colors.grey[200],
                                image: ImageHelper.buildDecorationImage(product.imagePath),
                              ),
                              child: product.imagePath.trim().isEmpty
                                  ? Icon(Icons.image, size: 18, color: Colors.grey)
                                  : null,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
