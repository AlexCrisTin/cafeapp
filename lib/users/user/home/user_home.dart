import 'package:flutter/material.dart';
import 'package:cafeproject/page/home/page_cafe.dart';
import 'package:cafeproject/page/home/item.dart';
import 'package:cafeproject/page/home/mostbuy.dart';
import 'package:cafeproject/page/home/message_page.dart';
import 'package:cafeproject/database/auth/auth_service.dart';
import 'package:cafeproject/database/auth/login_required.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService.instance;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFDC586D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20), 
                bottomRight: Radius.circular(20)
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(left: 10, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.person_2_outlined, size: 30, color: Colors.white),
                      title: Text(
                        'Chào mừng ${_auth.currentUser?.email ?? "User"}', 
                        style: TextStyle(color: Colors.white)
                      ),
                      subtitle: Text(
                        'Welcome to Cafe', 
                        style: TextStyle(color: Colors.white)
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_auth.isGuest || !_auth.isLoggedIn) {
                        final ok = await ensureLoggedIn(context);
                        if (!ok) return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MessagePage()),
                      );
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      child: Icon(Icons.message, color: Colors.white, size: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFFB959F)
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          PageCafe(),
          Item(),
          Mostbuy()
        ],
      ),
    );
  }
}
