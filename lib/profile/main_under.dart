import 'package:flutter/material.dart';

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
            Container(
              margin: EdgeInsets.only(left: 10, top: 20),
              width: 150,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.person),
                  Text('Voucher'),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10, top: 20),
              width: 150,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),                
                border: Border.all(color: Colors.red, width: 2)
              ),
              child: Row(
                children: [
                  Icon(Icons.delivery_dining),
                  Text('Đơn hàng'),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
              width: 340,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
            ),
        Container(
          margin: EdgeInsets.only(top: 20),
              width: 340,
              height:150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
            ),
      ],
    );
  }
}