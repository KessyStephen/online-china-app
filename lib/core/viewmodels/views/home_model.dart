import 'package:get/get.dart';
import 'package:online_china_app/core/enums/viewstate.dart';

import '../base_model.dart';

class HomeModel extends BaseModel {
  int currentIndex = 0;

  void navigateToTab(int index) async {
    setState(ViewState.Busy);
    currentIndex = index;
    setState(ViewState.Idle);
  }

  // Future<bool> handleStartUpLogic() async {
  //   setState(ViewState.Busy);
  //   // bool res = await this._startUpService.handleStartUplogic();
  //   setState(ViewState.Idle);
  //   return res;
  // }

  void addUserToStream() {
    setState(ViewState.Busy);
    // _startUpService.addUserToStream();
    setState(ViewState.Idle);
  }
}
