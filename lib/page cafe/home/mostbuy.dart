import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/product_data.dart';
import 'package:cafeproject/page%20cafe/home/itemdetail.dart';
import 'package:cafeproject/database/img/image_helper.dart';

class Mostbuy extends StatefulWidget {
  const Mostbuy({super.key});

  @override
  State<Mostbuy> createState() => _MostbuyState();
}

class _MostbuyState extends State<Mostbuy> {
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
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Text('Sản phẩm bán chạy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          ),
          SizedBox(
            height: 130,
            child: products.isEmpty 
              ? Center(child: Text('Đang tải sản phẩm...', style: TextStyle(color: Colors.grey[600])))
              : PageView.builder(
                  itemCount: (products.length / 3).ceil(), // Mỗi trang hiển thị 3 sản phẩm
                  itemBuilder: (context, pageIndex) {
                    final startIndex = pageIndex * 3;
                    final endIndex = (startIndex + 3).clamp(0, products.length);
                    final pageProducts = products.sublist(startIndex, endIndex);
                    return Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: pageProducts.map((product) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ItemDetailPage(product: product),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),                    
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.red, width: 2),
                                  image: ImageHelper.buildDecorationImage(product.imagePath),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
          )
        ],
      ),
    );
  }
}