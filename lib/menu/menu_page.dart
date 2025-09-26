import 'package:flutter/material.dart';
import 'package:cafeproject/menu/snack_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => SnackPage()));
                }, 
                child: Row(children: [Text('Đồ ăn vặt', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),), Icon(Icons.arrow_right_alt, size: 20,)]),),
              ],
            ),
          ),
        ),
        Container(
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
               ),
              ),
              Container(
                width: 100,
                height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
               ),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 100,
                height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
               ),
              ),
              Container(
                width: 100,
                height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
               ),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 100,
                height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
               ),
              ),
              Container(
                width: 100,
                height: 100,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
               ),
              )
            ],
          ),
        )
      ],
    );
  }
}