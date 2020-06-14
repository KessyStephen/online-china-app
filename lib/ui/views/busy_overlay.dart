import 'package:flutter/material.dart';

class BusyOverlay extends StatelessWidget {
  final Widget child;
  final String title;
  final bool show;

  const BusyOverlay(
      {this.child, this.title = 'Please wait...', this.show = false});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Material(
        child: Stack(children: <Widget>[
          child,
          IgnorePointer(
            child: Opacity(
                opacity: show ? 1.0 : 0.0,
                child: Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  alignment: Alignment.center,
                  color: Color.fromARGB(100, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ]));
  }
}
