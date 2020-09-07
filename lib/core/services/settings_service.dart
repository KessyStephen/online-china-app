import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/company_settings.dart';

import 'alert_service.dart';
import 'api.dart';

class SettingsService {
  final Api _api;
  final AlertService _alertService;

  SettingsService({@required Api api, @required AlertService alertService})
      : _api = api,
        _alertService = alertService;

  //companySettings - eg commissionRate etc
  CompanySettings _companySettings;
  CompanySettings get companySettings => _companySettings;

  Future<bool> getCompanySettings() async {
    var response = await this._api.getCompanySettings();

    if (response != null && response['success']) {
      var obj = response['data'];

      return processCompanySettings(obj);
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> processCompanySettings(obj) async {
    if (obj != null) {
      _companySettings = CompanySettings.fromJson(obj);
      return true;
    }

    return false;
  }
}
