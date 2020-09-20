import 'package:online_china_app/core/enums/constants.dart';

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map();
    data['value'] = this.value;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }

  static ExchangeRate getExchangeRate(List<ExchangeRate> allRates,
      {String from, String to}) {
    if (from == null || to == null) {
      return ExchangeRate(
          from: DEFAULT_CURRENCY, to: DEFAULT_CURRENCY, value: 1);
    }
    if (from == to) {
      return ExchangeRate(from: from, to: to, value: 1);
    }

    for (var obj in allRates) {
      if (obj.from == from && obj.to == to) {
        return obj;
      }
    }

    ExchangeRate usdToCurrency;
    ExchangeRate currencyToUSD;
    for (var obj in allRates) {
      if (obj.to == to && obj.from == "USD") {
        usdToCurrency = obj;
      }

      if (obj.from == from && obj.to == "USD") {
        currencyToUSD = obj;
      }
    }

    if (usdToCurrency != null && currencyToUSD != null) {
      return ExchangeRate(
          from: from, to: to, value: currencyToUSD.value * usdToCurrency.value);
    }

    return ExchangeRate(from: DEFAULT_CURRENCY, to: DEFAULT_CURRENCY, value: 1);
    // return null;
  }
}
