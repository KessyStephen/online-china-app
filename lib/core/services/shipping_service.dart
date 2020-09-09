import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/helpers/utils.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/category_service.dart';
import 'package:online_china_app/core/services/settings_service.dart';

import 'alert_service.dart';
import 'api.dart';

class ShippingService {
  final Api _api;
  final AlertService _alertService;
  final CategoryService _categoryService;
  final SettingsService _settingsService;

  ShippingService(
      {@required Api api,
      @required AlertService alertService,
      @required CategoryService categoryService,
      @required SettingsService settingsService})
      : _api = api,
        _alertService = alertService,
        _categoryService = categoryService,
        _settingsService = settingsService;

  double calculateAirShippingCost({List<Product> products}) {
    if (products == null || products.length == 0) {
      return 0;
    }

    double total = 0;
    for (var item in products) {
      total += item.weight * item.quantity;
    }

    double shippingPricePerKg =
        _settingsService?.companySettings?.shippingPricePerKg ?? 0;
    return total * shippingPricePerKg;
  }

  double calculateSeaShippingCost({List<Product> products}) {
    if (products == null || products.length == 0) {
      return 0;
    }

    double total = 0;
    for (var item in products) {
      double tmpCBM = Utils.calculateCBM(item.length, item.width, item.height);
      double totalCBM = tmpCBM * item.quantity;

      Category category =
          Category.getCategory(item.categoryId, _categoryService.allCategories);
      double shippingPricePerCBM = category?.shippingPricePerCBM ?? 0;
      total += shippingPricePerCBM * totalCBM;
    }

    return total;
  }
}
