import 'package:flutter/material.dart';
import 'package:cafeproject/login/login.dart';
import 'package:cafeproject/login/signup.dart';
import 'package:cafeproject/home/main_cafe.dart';
class Begin extends StatefulWidget {
  const Begin({super.key});

  @override
  State<Begin> createState() => _BeginState();
}

class _BeginState extends State<Begin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          InkWell( 
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Container(
              height: 100,
              width: 100,
              color: Colors.red,
              child: Text('Đăng nhập'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
            },
            child: Container(
            height: 100,
            width: 100,
            color: Colors.blue,
            child: Text('Đăng ký'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainCafe()));
            },
            child: Container(
              height: 100,
              width: 100,
              color: Colors.green,
              child: Text('Khách'),
            ),
          ),
        ],
      ),
    );
  }
}