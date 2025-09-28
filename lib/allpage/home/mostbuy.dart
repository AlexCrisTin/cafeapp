import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/product_data.dart';
import 'package:cafeproject/allpage/home/itemdetail.dart';

class Mostbuy extends StatefulWidget {
  const Mostbuy({super.key});

  @override
  State<Mostbuy> createState() => _MostbuyState();
}

class _MostbuyState extends State<Mostbuy> {
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
            child: PageView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                final product = ProductData.getProductById('${index + 1}');
                return Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (product != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ItemDetailPage(product: product),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red),
                            image: product != null
                          ? DecorationImage(
                              image: AssetImage(product.imagePath),
                              fit: BoxFit.cover,
                            )
                          : null,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (product != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ItemDetailPage(product: product),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red),
                            image: product != null
                          ? DecorationImage(
                              image: AssetImage(product.imagePath),
                              fit: BoxFit.cover,
                            )
                          : null,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (product != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ItemDetailPage(product: product),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red),
                            image: product != null
                          ? DecorationImage(
                              image: AssetImage(product.imagePath),
                              fit: BoxFit.cover,
                            )
                          : null,
                          ),
                        ),
                      ),
                    ],
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