import 'package:flutter/material.dart';
import 'package:cafeproject/profile/orders_page.dart';
import 'package:cafeproject/setting/setting.dart';
class MainUnder extends StatefulWidget {
  const MainUnder({super.key});

  @override
  State<MainUnder> createState() => _MainUnderState();
}

class _MainUnderState extends State<MainUnder> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}