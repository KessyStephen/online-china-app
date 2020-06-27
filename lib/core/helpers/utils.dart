import 'package:intl/intl.dart';

class Utils {
  static String displayDate(DateTime dtime) {
    return dtime != null ? DateFormat('d MMMM y').format(dtime) : "";
  }
}
