import 'package:flutter/material.dart';

class AdminAnalytics extends StatelessWidget {
  const AdminAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thống kê & Báo cáo'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue Chart Placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart, size: 50, color: Colors.grey[400]),
                  SizedBox(height: 10),
                  Text(
                    'Biểu đồ doanh thu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Sẽ được phát triển sớm',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Analytics Cards
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsCard(
                    'Doanh thu hôm nay',
                    '2,450,000 VNĐ',
                    Icons.trending_up,
                    Colors.green,
                    '+12%',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildAnalyticsCard(
                    'Đơn hàng hôm nay',
                    '45',
                    Icons.shopping_cart,
                    Colors.blue,
                    '+8%',
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsCard(
                    'Khách hàng mới',
                    '12',
                    Icons.person_add,
                    Colors.orange,
                    '+15%',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildAnalyticsCard(
                    'Sản phẩm bán chạy',
                    'Cà phê đen',
                    Icons.star,
                    Colors.purple,
                    'Top 1',
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Detailed Analytics
            Text(
              'Phân tích chi tiết',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            _buildDetailCard(
              'Báo cáo doanh thu theo tháng',
              'Xem chi tiết doanh thu từng tháng',
              Icons.calendar_month,
              Colors.green,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mở báo cáo doanh thu')),
                );
              },
            ),

            _buildDetailCard(
              'Phân tích sản phẩm bán chạy',
              'Top sản phẩm được yêu thích nhất',
              Icons.trending_up,
              Colors.blue,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mở phân tích sản phẩm')),
                );
              },
            ),

            _buildDetailCard(
              'Thống kê khách hàng',
              'Phân tích hành vi và sở thích khách hàng',
              Icons.people,
              Colors.orange,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mở thống kê khách hàng')),
                );
              },
            ),

            _buildDetailCard(
              'Xuất báo cáo',
              'Tải báo cáo dưới dạng PDF/Excel',
              Icons.download,
              Colors.purple,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Xuất báo cáo')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
