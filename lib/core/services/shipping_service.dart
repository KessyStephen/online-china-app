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

  Map<String, dynamic> calculateAirShippingCost({List<Product> products}) {
    if (products == null || products.length == 0) {
      return {"totalWeight": 0, "totalCost": 0};
    }

    double total = 0;
    for (var item in products) {
      total += item.weight * item.quantity;
    }

    double shippingPricePerKg =
        _settingsService?.companySettings?.shippingPricePerKg ?? 0;
    var totalPrice = total * shippingPricePerKg;

    return {"totalWeight": total, "totalCost": totalPrice};
  }

  Map<String, dynamic> calculateSeaShippingCost({List<Product> products}) {
    if (products == null || products.length == 0) {
      return {"totalCBM": 0, "totalCost": 0};
    }

    double globalTotalCBM = 0;

    double total = 0;
    for (var item in products) {
      double tmpCBM = Utils.calculateCBM(item.length, item.width, item.height);
      double totalCBM = tmpCBM * item.quantity;
      globalTotalCBM += totalCBM;

      Category category =
          Category.getCategory(item.categoryId, _categoryService.allCategories);
      double shippingPricePerCBM = category?.shippingPricePerCBM ?? 0;
      total += shippingPricePerCBM * totalCBM;
    }

    return {"totalCBM": globalTotalCBM, "totalCost": total};
  }
}
