import 'package:flutter/material.dart';
class PageCafe extends StatefulWidget {
  const PageCafe({super.key});

  @override
  State<PageCafe> createState() => _PageCafeState();
}

class _PageCafeState extends State<PageCafe> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: PageView.builder(
        itemCount: 5,
        itemBuilder: (context, position) {
          return buildPage(position);
        },
      ),
    );
  }

  Widget buildPage(int index) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage('https://insanelygoodrecipes.com/wp-content/uploads/2020/07/Cup-Of-Creamy-Coffee.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}