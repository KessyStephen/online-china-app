import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/helpers/shared_prefs.dart';

class LangUtils {
  static String getCurrentLocale() {
    return "en";
  }

  static Future<String> getSelectedCurrency() async {
    var tmp = await SharedPrefs.getString(SELECTED_CURRENCY_KEY);
    return tmp ?? DEFAULT_CURRENCY;
  }
}
