import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 1.0)),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Search Online China'),
              )),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
