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
}
