import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/banner_item.dart';

import 'alert_service.dart';
import 'api.dart';

class BannerService {
  final Api _api;
  final AlertService _alertService;

  BannerService({@required Api api, @required AlertService alertService})
      : _api = api,
        _alertService = alertService;

  List<BannerItem> _banners = [];
  List<BannerItem> get banners => _banners;

  Future<bool> getBanners() async {
    _banners.clear();

    var response = await this._api.getBanners();
    if (response != null && response['success']) {
      var tmpArray = response['data'];

      return processBanners(tmpArray);
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> processBanners(tmpArray) async {
    _banners.clear();

    if (tmpArray == null || tmpArray.length == 0) {
      return false;
    }

    for (int i = 0; i < tmpArray.length; i++) {
      _banners.add(BannerItem.fromJson(tmpArray[i]));
    }

    return true;
  }
}
