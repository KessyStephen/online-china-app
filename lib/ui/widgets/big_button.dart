import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final Function functionality;
  final String buttonTitle;
  final Color color;

  const BigButton({Key key, this.functionality, this.buttonTitle, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: FlatButton(
        padding: EdgeInsets.all(15.0),
        color: this.color != null ? this.color : primaryColor,
        child: Text(
          buttonTitle,
          style: TextStyle(
              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w800),
        ),
        onPressed: () => functionality(),
      ),
    );
  }
}
