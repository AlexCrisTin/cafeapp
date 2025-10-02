import 'package:flutter/material.dart';

class Voucher extends StatefulWidget {
  const Voucher({super.key});

  @override
  State<Voucher> createState() => _VoucherState();
}

class _VoucherState extends State<Voucher> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Voucher', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),),
            ],
          ),
        ),
        Container(
        height: 160,
        color: Colors.transparent,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            _buildVoucherCard(
              title: 'Giảm 20%',
              desc: 'Cho đơn từ 100.000đ',
              colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
            ),
            _buildVoucherCard(
              title: 'Freeship',
              desc: 'Áp dụng cho mọi đơn',
              colors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
            ),
            _buildVoucherCard(
              title: 'Mua 2 tặng 1',
              desc: 'Áp dụng đồ uống',
              colors: [Color(0xFF84FAB0), Color(0xFF8FD3F4)],
            ),
          ],
        ),
      ),
      ],
    );
  }

  Widget _buildVoucherCard({required String title, required String desc, required List<Color> colors}) {
    return Container(
      width: 260,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: Stack(
        children: [
          // dotted separator
          Positioned(
            left: 100,
            top: 0,
            bottom: 0,
            child: Container(
              width: 1,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.white.withOpacity(0.7),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black26, offset: Offset(0,1), blurRadius: 2)],
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        desc,
                        style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tính năng mới sẽ được phát triển')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Dùng ngay'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
    