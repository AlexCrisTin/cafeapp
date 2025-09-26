import 'package:flutter/material.dart';
import 'package:cafeproject/profile/main_under.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.red,
            height: 200,
          ),
          Expanded(child: MainUnder()),
        ],
      ),
    );
  }
}
