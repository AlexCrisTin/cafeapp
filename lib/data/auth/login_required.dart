import 'package:flutter/material.dart';
import 'package:cafeproject/login/login.dart';
import 'package:cafeproject/data/auth/auth_service.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (AuthService.instance.isLoggedIn) {
    return true;
  }

  final bool? result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Cần đăng nhập'),
      content: Text('Bạn cần đăng nhập để thực hiện thao tác này.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
          child: Text('Đăng nhập'),
        ),
      ],
    ),
  );

  return result == true;
}


