import 'dart:async';
import 'package:online_china_app/core/models/AlertRequest.dart';


class AlertService {
  Function(AlertRequest) _showAlertLister;
  Completer _alertCompleter;

  void registerAlertListener(Function(AlertRequest) showAlertListener){
    _showAlertLister = showAlertListener;
  }

  Future showAlert({String text, bool error}){
    _alertCompleter = Completer();
    _showAlertLister(AlertRequest(text:text, error: error));
    return _alertCompleter.future;
  }


  void aletComplete(){
    _alertCompleter.complete();
  }
}