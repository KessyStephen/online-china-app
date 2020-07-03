import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class EmptyListWidget extends StatelessWidget {
  final String message;

  const EmptyListWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration:
            BoxDecoration(color: Colors.redAccent[100], shape: BoxShape.circle),
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Entypo.archive,
              size: 64,
              color: Colors.white,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              message,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
