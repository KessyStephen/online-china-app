import 'package:flutter/widgets.dart';
import 'package:online_china_app/core/enums/viewstate.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  bool disposed = false;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    if (!disposed) {
      _state = viewState;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    this.disposed = true;
  }
}
