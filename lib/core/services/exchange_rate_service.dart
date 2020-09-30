import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/exchange_rate.dart';

import 'alert_service.dart';
import 'api.dart';

class ExchangeRateService {
  final Api _api;
  final AlertService _alertService;

  ExchangeRateService({@required Api api, @required AlertService alertService})
      : _api = api,
        _alertService = alertService;

  List<ExchangeRate> _exchangeRates = [];
  List<ExchangeRate> get exchangeRates => _exchangeRates;

  Future<bool> getExchangeRates() async {
    var response = await this._api.getExchangeRates();

    if (response != null && response['success']) {
      var tmpArray = response['data'];
      return processExchangeRates(tmpArray);
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> processExchangeRates(tmpArray) async {
    if (tmpArray == null || tmpArray.length == 0) {
      return false;
    }

    _exchangeRates.clear();

    for (int i = 0; i < tmpArray.length; i++) {
      var tmpObj = tmpArray[i];
      if (tmpObj["from"] != null &&
          tmpObj["to"] != null &&
          tmpObj["value"] != null &&
          tmpObj["value"] > 0) {
        _exchangeRates.add(ExchangeRate.fromJson(tmpObj));

        //inverse
        var to = tmpObj["from"];
        tmpObj["from"] = tmpObj["to"];
        tmpObj["to"] = to;
        tmpObj["value"] = 1 / double.parse(tmpObj['value'].toString());

        _exchangeRates.add(ExchangeRate.fromJson(tmpObj));
      }
    }

    return true;
  }
}
