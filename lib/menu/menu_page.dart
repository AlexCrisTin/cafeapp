import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.red,
            height: 70,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Menu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
