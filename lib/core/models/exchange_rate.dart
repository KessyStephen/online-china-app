class ExchangeRate {
  double value;
  String from;
  String to;

  ExchangeRate({this.value, this.from, this.to});

  ExchangeRate.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    value = map['value'] != null ? double.parse(map['value'].toString()) : 0;
    from = map['from'];
    to = map['to'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map();
    data['value'] = this.value;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}
