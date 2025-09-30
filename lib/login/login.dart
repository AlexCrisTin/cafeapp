import 'package:flutter/material.dart';
import 'package:cafeproject/login/signup.dart';
import 'package:cafeproject/login/begin.dart';
import 'package:cafeproject/database/auth/auth_service.dart';
import 'package:cafeproject/database/auth/navigation_helper.dart';
import 'package:cafeproject/users/guest/guest_main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
        backgroundColor: Color(0xFFffbb99),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            ],
            const Text(
              'Thông tin đăng nhập',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Tên đăng nhập',
                hintText: 'Nhập tên đăng nhập',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text;
                  
                  if (email.isEmpty || password.isEmpty) {
                    setState(() { _error = 'Vui lòng nhập đầy đủ thông tin'; });
                    return;
                  }
                  
                  final ok = AuthService.instance.loginWithCredentials(email, password);
                  if (!ok) {
                    setState(() { _error = 'Email hoặc mật khẩu không đúng'; });
                    return;
                  }
                  
                  setState(() { _error = null; });
                  NavigationHelper.navigateAfterLogin(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFffbb99),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Đăng nhập', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: const Text('Đăng ký', style: TextStyle(color: Color(0xFFffbb99))),
                ),
                ElevatedButton(
                  onPressed: () {
                    AuthService.instance.continueAsGuest();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GuestMain()));
                  },
                  child: const Text('Khách', style: TextStyle(color: Color(0xFFffbb99))),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Begin()));
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFffbb99),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text('Quay lại', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}