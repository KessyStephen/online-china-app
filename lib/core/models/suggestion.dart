class Suggestion {
  String title;

  Suggestion({this.title});

  Suggestion.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    title = map['suggestion'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map();
    data['title'] = this.title;
    return data;
  }
}
