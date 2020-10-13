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
        children: <Widget>[
          Text(
            this.leftText != null ? this.leftText : "",
            textAlign: TextAlign.start,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
              flex: 1,
              child: Text(
                this.rightText != null ? this.rightText : "",
                textAlign: TextAlign.end,
              )),
        ],
      ),
    );
  }
}
