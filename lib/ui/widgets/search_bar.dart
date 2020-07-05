import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;

  final bool disableTextField;
  final bool autofocus;

  final TextEditingController controller;
  final Function onSubmitPressed;

  const SearchBar(
      {Key key,
      this.backgroundColor,
      this.textColor,
      this.disableTextField,
      this.autofocus,
      this.controller,
      this.onSubmitPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.only(left: 10),
      color: this.backgroundColor != null ? this.backgroundColor : Colors.white,
      // decoration: BoxDecoration(
      //     color: this.backgroundColor != null
      //         ? this.backgroundColor
      //         : Colors.white,
      //     border: Border.all(color: Colors.grey, width: 1.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: TextField(
                autofocus: this.autofocus == true,
                controller: this.controller,
                enabled: this.disableTextField == null ||
                    this.disableTextField == false,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search Online China',
                    hintStyle: TextStyle(
                        color: this.textColor != null ? this.textColor : null)),
              )),
          IconButton(
            onPressed: this.onSubmitPressed,
            icon: Icon(Icons.search, color: Colors.white54),
          )
        ],
      ),
    );
  }
}
