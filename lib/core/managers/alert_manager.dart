import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/AlertRequest.dart';
import 'package:online_china_app/core/services/alert_service.dart';


class AlertManager extends StatefulWidget {
  final Widget child;
  final AlertService alertService;
  AlertManager({Key key, this.child, this.alertService}) : super(key: key);

  _AlertManagerState createState() => _AlertManagerState();
}

class _AlertManagerState extends State<AlertManager> {

  @override
  void initState() {
    super.initState();
    widget.alertService.registerAlertListener(_showAlert);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }

  void _showAlert(AlertRequest request) {
    if (request.text.isNotEmpty && request.text != null)
      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        flushbarPosition: FlushbarPosition.TOP,
        message: request.text,
        icon: request.error
            ? Icon(
                Icons.error_outline,
                size: 28.0,
                color: Colors.white,
              )
            : Icon(
                Icons.check,
                size: 28.0,
                color: Colors.white,
              ),
        duration: Duration(seconds: 6),
        backgroundColor: request.error ? Colors.red[500] : Colors.green[300],
      )..show(context);
  }
}
