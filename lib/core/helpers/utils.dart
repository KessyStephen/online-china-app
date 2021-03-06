import 'package:intl/intl.dart';
import 'package:html/parser.dart' show parse;

class Utils {
  static String displayDate(DateTime dtime) {
    return dtime != null ? DateFormat('d MMMM y').format(dtime) : "";
  }

  static String removeHtmlTags(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  static String formatNumber(double value) {
    if (value == null) {
      return "";
    }

    var f = new NumberFormat.currency(locale: "en_US", symbol: "");
    return f.format(value);
  }

  static double calculateCBM(double lengthCM, double widthCM, double heightCM) {
    if (lengthCM == null || widthCM == null || heightCM == null) {
      return 0;
    }

    return (lengthCM * widthCM * heightCM) / 1000000;
  }
}
