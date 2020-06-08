import 'dart:async';
import 'package:online_china_app/core/models/DialogRequest.dart';
import 'package:online_china_app/core/models/DialogResponse.dart';


class DialogService {
  Function(DialogRequest) _showDialogLister;
  Completer<DialogResponse> _dialogCompleter;

  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogLister = showDialogListener;
  }

  Future<DialogResponse> showDialog({title, description}) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogLister(DialogRequest(title: title, description: description));
    return _dialogCompleter.future;
  }

  void dialogComplete(DialogResponse dialogResponse) {
    _dialogCompleter.complete(dialogResponse);
    _dialogCompleter = null;
  }
}
