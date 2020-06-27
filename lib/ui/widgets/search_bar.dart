import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final bool disableTextField;
  final TextEditingController controller;
  final Function onSubmitPressed;

  const SearchBar(
      {Key key, this.disableTextField, this.controller, this.onSubmitPressed})
      : super(key: key);

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
                controller: this.controller,
                enabled: this.disableTextField == null ||
                    this.disableTextField == false,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Search Online China'),
              )),
          IconButton(
            onPressed: this.onSubmitPressed,
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
