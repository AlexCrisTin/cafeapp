import 'package:flutter/material.dart';
import 'package:cafeproject/page%20cafe/menu/menu_page.dart';
class MenuHead extends StatelessWidget {
  const MenuHead({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            color: Color(0xFFffbb94),
            height: 70,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Menu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
              ],
            ),
          ),
          MenuPage(),
        ],
      );
  }
}
