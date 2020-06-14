import 'package:get/get.dart';

class NavigationService {
  Future<dynamic> navigateTo(String routeName) {
    return Get.key.currentState.pushNamed(routeName);
  }

  void navigateAndNeverReturn(String routeName) {
    Get.key.currentState.pushReplacementNamed(routeName);
  }

}
