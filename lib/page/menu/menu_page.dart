import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/product_data.dart';
import 'package:cafeproject/page/home/itemdetail.dart';
import 'package:cafeproject/page/menu/category_products_page.dart';
import 'package:cafeproject/page/home/item.dart';
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
            color: Colors.white,
            width: double.infinity,
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
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Text('Gợi ý cho bạn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
              item1(productId: '1'),
              item1(productId: '2'),
              item1(productId: '3'),  
              item1(productId: '4'),
              item1(productId: '5'),
            ],
          ),
        )
      ],
    );
  }
}