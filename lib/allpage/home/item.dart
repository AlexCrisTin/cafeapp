import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/product_data.dart';
import 'package:cafeproject/allpage/home/itemdetail.dart';

class Item extends StatefulWidget {
  const Item({super.key});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10, left: 10),
          child: Text('Gợi ý cho bạn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          
        ),
        item1(productId: '1'),
        item1(productId: '2'),
        item1(productId: '3'),  
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
          child: Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent, width: 3),
                    color: Colors.white,
                    image: product != null
                        ? DecorationImage(
                            image: AssetImage(product.imagePath),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 10),
                  height: 100,
                  width: 280,                 
                  child: Column(
                    children: [
                      Text(product?.name ?? 'Sản phẩm'),
                      Text(product?.category ?? ''),
                      Text(product != null ? product.price.toStringAsFixed(0) + ' đ' : ''),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

