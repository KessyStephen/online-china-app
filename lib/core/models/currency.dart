class Currency {
  String id;
  String symbol;
  String currency;
  String code;
  bool active;

  Currency({this.id, this.symbol, this.currency, this.code, this.active});

  Currency.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    id = map['id'];
    symbol = map['symbol'];
    currency = map['currency'];
    code = map['code'];
    active = map['active'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map();
    data['id'] = this.id;
    data['symbol'] = this.symbol;
    data['currency'] = this.currency;
    data['code'] = this.code;
    data['active'] = this.active;

    return data;
  }
}
