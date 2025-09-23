import 'package:flutter/material.dart';

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () {}, 
              child: Row(children: [Text('Đồ ăn vặt', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),), Icon(Icons.arrow_right_alt, size: 20,)]),),
            ],
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
              )
            ],
          ),
        )
      ],
    );
  }
}