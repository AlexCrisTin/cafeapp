import 'package:flutter/material.dart';
import 'package:cafeproject/data/product_data.dart';
import 'package:cafeproject/home/itemdetail.dart';
import 'package:cafeproject/menu/category_products_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  void _openProduct(BuildContext context, String productId) {
    final product = ProductData.getProductById(productId);
    if (product != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ItemDetailPage(product: product)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy sản phẩm')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CategoryProductsPage(category: 'Đồ uống'),
                      ),
                    );
                  },
                  child: Container(
                  margin: EdgeInsets.all(10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Icon(Icons.coffee, size: 20,),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CategoryProductsPage(category: 'Đồ ăn'),
                      ),
                    );
                  },
                  child: Container(
                  margin: EdgeInsets.all(10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Icon(Icons.coffee, size: 20,),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CategoryProductsPage(category: 'Đồ uống'),
                      ),
                    );
                  },
                  child: Container(
                  margin: EdgeInsets.all(10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Icon(Icons.coffee, size: 20,),              
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CategoryProductsPage(category: 'Đồ ăn'),
                      ),
                    );
                  },
                  child: Container(
                  margin: EdgeInsets.all(10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Icon(Icons.coffee, size: 20,),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CategoryProductsPage(category: 'Đồ uống'),
                      ),
                    );
                  },
                  child: Container(
                  margin: EdgeInsets.all(10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Icon(Icons.coffee, size: 20,),
                  ),
                ),
              ]
            )
          )
        ),
        Container(
          child: Row(
            children: [
              InkWell(
                onTap: () => _openProduct(context, '1'),
                child: Container(
                width: 100,
                height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
               ),
               ),
              ),
              InkWell(
                onTap: () => _openProduct(context, '2'),
                child: Container(
                width: 100,
                height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
               ),
               ),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => _openProduct(context, '3'),
                child: Container(
                width: 100,
                height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
               ),
               ),
              ),
              InkWell(
                onTap: () => _openProduct(context, '4'),
                child: Container(
                width: 100,
                height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
               ),
               ),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => _openProduct(context, '5'),
                child: Container(
                width: 100,
                height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
               ),
               ),
              ),
              InkWell(
                onTap: () => _openProduct(context, '1'),
                child: Container(
                width: 100,
                height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
               ),
               ),
              )
            ],
          ),
        )
      ],
    );
  }
}