import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class BigButtonOutline extends StatelessWidget {
  final Function functionality;
  final String buttonTitle;

  const BigButtonOutline({Key key, this.functionality, this.buttonTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: OutlineButton(
        padding: EdgeInsets.all(20.0),
        borderSide: BorderSide(color: primaryColor),
        color: primaryColor,
        child: Text(
          buttonTitle,
          style: TextStyle(
              color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w800),
        ),
        onPressed: () => functionality(),
      ),
    );
  }
}
