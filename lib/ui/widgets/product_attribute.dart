import 'package:flutter/material.dart';

class ProductAttribute extends StatelessWidget {
  final String leftText;
  final String rightText;

  const ProductAttribute({Key key, this.leftText, this.rightText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(this.leftText != null ? this.leftText : ""),
          Text(this.rightText != null ? this.rightText : ""),
        ],
      ),
    );
  }
}
