import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  const Item({super.key});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Text('Item 1'),
          color: Colors.red,
        ),
        item1(),
        item1(),
        item1(),  
      ],
    );
  }
}
class item1 extends StatefulWidget {
  const item1({super.key});

  @override
  State<item1> createState() => _item1State();
}

class _item1State extends State<item1> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 100,
                width: 280,
                color: Colors.blue,
                child: Column(
                  children: [
                    Text('Item 2'),
                    Text('Item 3'),
                    Text('Item 4'),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}