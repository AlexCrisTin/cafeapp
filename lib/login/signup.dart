import 'package:flutter/material.dart';
import 'package:cafeproject/home/main_cafe.dart';
import 'package:cafeproject/login/login.dart';
import 'package:cafeproject/login/begin.dart';
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Email',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainCafe()));
            },
            child: Text('Signup'),
          ),
        ],
      ),
    );
  }
}