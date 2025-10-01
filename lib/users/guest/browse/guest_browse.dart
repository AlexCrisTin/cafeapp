import 'package:flutter/material.dart';
import 'package:cafeproject/page%20cafe/home/page_cafe.dart';
import 'package:cafeproject/page%20cafe/home/item.dart';
import 'package:cafeproject/page%20cafe/home/mostbuy.dart';
import 'package:cafeproject/database/auth/auth_service.dart';
import 'package:cafeproject/login/begin.dart';

class GuestBrowse extends StatelessWidget {
  const GuestBrowse({super.key});

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
                        'Chào mừng khách hàng', 
                        style: TextStyle(color: Colors.white)
                      ),
                      subtitle: Text(
                        'Khám phá menu của chúng tôi', 
                        style: TextStyle(color: Colors.white)
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => Begin()),
                      );
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      child: Icon(Icons.login, color: Colors.white, size: 20),
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
          
          // Guest Notice
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange[700]),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bạn đang xem với tư cách khách',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                      Text(
                        'Đăng nhập để đặt hàng và lưu thông tin',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[600],
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => Begin()),
                    );
                  },
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(color: Colors.orange[700]),
                  ),
                ),
              ],
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
