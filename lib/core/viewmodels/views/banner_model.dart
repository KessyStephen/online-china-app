import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/banner_item.dart';
import 'package:online_china_app/core/services/banner_service.dart';

import '../base_model.dart';

class BannerModel extends BaseModel {
  final BannerService _bannerService;
  BannerModel({@required BannerService bannerService})
      : _bannerService = bannerService;

  List<BannerItem> get banners => _bannerService.banners;

  Future<bool> getBanners({hideLoading = false}) async {
    if (hideLoading) {
      setState(ViewState.Busy);
    }
    bool response = await _bannerService.getBanners();
    setState(ViewState.Idle);
    return response;
  }
}
