import 'package:flutter/material.dart';

class DetailsHeader extends StatelessWidget {
  final String title;
  final String rightText;
  final Function onPressed;

  const DetailsHeader({Key key, this.title, this.rightText, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(this.title != null ? this.title : "",
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          if (this.rightText != null)
            InkWell(
              onTap: this.onPressed,
              child: Text(
                this.rightText != null ? this.rightText : "",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
            ),
        ],
      ),
    );
  }
}
