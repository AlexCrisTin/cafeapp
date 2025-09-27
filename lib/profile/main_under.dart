import 'package:flutter/material.dart';
import 'package:cafeproject/profile/orders_page.dart';
import 'package:cafeproject/setting/setting.dart';
import 'package:cafeproject/login/begin.dart';
class MainUnder extends StatefulWidget {
  const MainUnder({super.key});

  @override
  State<MainUnder> createState() => _MainUnderState();
}

class _MainUnderState extends State<MainUnder> {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đăng xuất'),
          content: Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                // Xóa tất cả dữ liệu và quay về trang đăng nhập
                _performLogout(context);
              },
              child: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) async {
    // Có thể thêm logic xóa dữ liệu user ở đây nếu cần
    // Ví dụ: xóa token, clear cache, etc.
    
    // Quay về trang Begin (trang đăng nhập)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Begin()),
      (route) => false, // Xóa tất cả route trước đó
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('sẽ phát triển sớm')),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 20),
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 6),
                        Text('Voucher'),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const OrdersPage()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10, top: 20),
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),                
                      border: Border.all(color: Colors.red, width: 2)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delivery_dining, size: 20,),
                        Text('Đơn hàng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
                width: 340,
                height: 100,
                child: Row(
                  children: [
                    Icon(Icons.ac_unit, size: 20,),
                    Text('Quay ngay nhận quà', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
              ),
          Container(
            margin: EdgeInsets.only(top: 20),
                width: 340,
                height:170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.ac_unit, size: 20,),
                      title: Text('Thẻ hội viên', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    ListTile(
                      leading: Icon(Icons.ac_unit, size: 20,),
                      title: Text('Thông tin cá nhân', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SettingPage()),
                        );
                      },
                      child: ListTile(
                        leading: Icon(Icons.ac_unit, size: 20,),
                        title: Text('Cài đặt', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ],
                ),
              ),
          // Container Logout
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 340,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red, width: 2),
              color: Colors.red[50],
            ),
            child: InkWell(
              onTap: () {
                _showLogoutDialog(context);
              },
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.red, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Đăng xuất',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}