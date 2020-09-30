import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/helpers/lang_utils.dart';
import 'package:online_china_app/core/helpers/utils.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/models/exchange_rate.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/category_service.dart';
import 'package:online_china_app/core/services/exchange_rate_service.dart';
import 'package:online_china_app/core/services/product_service.dart';
import 'package:online_china_app/core/services/settings_service.dart';

import 'alert_service.dart';
import 'api.dart';

class ShippingService {
  final Api _api;
  final AlertService _alertService;
  final CategoryService _categoryService;
  final SettingsService _settingsService;
  final ExchangeRateService _exchangeRateService;

  ShippingService(
      {@required Api api,
      @required AlertService alertService,
      @required CategoryService categoryService,
      @required SettingsService settingsService,
      @required ProductService productService,
      @required ExchangeRateService exchangeRateService})
      : _api = api,
        _alertService = alertService,
        _categoryService = categoryService,
        _settingsService = settingsService,
        _exchangeRateService = exchangeRateService;

  List<ExchangeRate> get exchangeRates => _exchangeRateService.exchangeRates;

  Future<Map<String, dynamic>> calculateAirShippingCost(
      {List<Product> products}) async {
    if (products == null || products.length == 0) {
      return {"totalWeight": 0, "totalCost": 0};
    }

    double total = 0;
    for (var item in products) {
      if (item.shippingWeightQuantity != null &&
          item.shippingWeightQuantity > 0 &&
          item.shippingWeightValue != null) {
        total += (item.shippingWeightValue / item.shippingWeightQuantity) *
            item.quantity;
      } else {
        total += item.weight * item.quantity;
      }
    }

    //convert shipping price from usd
    double exchangeRateValue = 1;
    String toCurrency = await LangUtils.getSelectedCurrency();
    var exchangeRate = ExchangeRate.getExchangeRate(exchangeRates,
        from: "USD", to: toCurrency);
    if (exchangeRate?.value != null) {
      exchangeRateValue = exchangeRate.value;
    }

    double shippingPricePerKg =
        _settingsService?.companySettings?.shippingPricePerKg ?? 0;
    var totalPrice = total * shippingPricePerKg * exchangeRateValue;

    return {"totalWeight": total, "totalCost": totalPrice};
  }

  Future<Map<String, dynamic>> calculateSeaShippingCost(
      {List<Product> products}) async {
    if (products == null || products.length == 0) {
      return {"totalCBM": 0, "totalCost": 0};
    }

    //convert shipping price from usd
    double exchangeRateValue = 1;
    String toCurrency = await LangUtils.getSelectedCurrency();
    var exchangeRate = ExchangeRate.getExchangeRate(exchangeRates,
        from: "USD", to: toCurrency);
    if (exchangeRate?.value != null) {
      exchangeRateValue = exchangeRate.value;
    }

    double globalTotalCBM = 0;

    double total = 0;
    for (var item in products) {
      double tmpCBM = 0;
      if (item.shippingCBMQuantity != null &&
          item.shippingCBMQuantity > 0 &&
          item.shippingCBMValue != null) {
        tmpCBM = item.shippingCBMValue / item.shippingCBMQuantity;
      } else {
        tmpCBM = Utils.calculateCBM(item.length, item.width, item.height);
      }

      double totalCBM = tmpCBM * item.quantity;
      globalTotalCBM += totalCBM;

      Category category =
          Category.getCategory(item.categoryId, _categoryService.allCategories);
      double shippingPricePerCBM = category?.shippingPricePerCBM ?? 0;
      total += shippingPricePerCBM * totalCBM * exchangeRateValue;
    }

    return {"totalCBM": globalTotalCBM, "totalCost": total};
  }
}
