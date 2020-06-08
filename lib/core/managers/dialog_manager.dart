import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/DialogRequest.dart';
import 'package:online_china_app/core/models/DialogResponse.dart';
import 'package:online_china_app/core/services/dialog_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class DialogManager extends StatefulWidget {
  final Widget child;
  final DialogService dialogService;

  DialogManager({
    Key key,
    this.child,
    this.dialogService
  }) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  @override
  void initState() {
    super.initState();
    widget.dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }

  void _showDialog(DialogRequest dialogRequest) {
    Alert(
        context: context,
        title: dialogRequest.title,
        desc: dialogRequest.description,
        closeFunction: () =>
            widget.dialogService.dialogComplete(DialogResponse(isConfirmed: false)),
        buttons: [
          DialogButton(
            child: Text(
              'Yes',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              widget.dialogService.dialogComplete(DialogResponse(isConfirmed: true));
              Navigator.of(context).pop();
            },
          )
        ]).show();
  }
}
