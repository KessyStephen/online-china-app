import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/helpers/lang_utils.dart';
import 'package:online_china_app/core/helpers/utils.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/models/elastic_product.dart';
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
      return {"totalCBM": 0, "totalWeight": 0, "totalCost": 0};
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
    double globalTotalWeight = 0;

    double totalCost = 0;
    for (var item in products) {
      //item CBM
      double tmpCBM = 0;
      if (item.shippingCBMQuantity != null &&
          item.shippingCBMQuantity > 0 &&
          item.shippingCBMValue != null) {
        tmpCBM = item.shippingCBMValue / item.shippingCBMQuantity;
      } else {
        tmpCBM = Utils.calculateCBM(item.length, item.width, item.height);
      }

      //item weight
      double tmpWeight = 0;
      if (item.shippingWeightQuantity != null &&
          item.shippingWeightQuantity > 0 &&
          item.shippingWeightValue != null) {
        tmpWeight = item.shippingWeightValue / item.shippingWeightQuantity;
      } else {
        tmpWeight = item.weight;
      }

      double totalCBM = tmpCBM * item.quantity;
      double totalWeight = tmpWeight * item.quantity;
      globalTotalCBM += totalCBM;
      globalTotalWeight += totalWeight;

      Category category =
          Category.getCategory(item.categoryId, _categoryService.allCategories);
      double shippingPrice = category?.shippingPriceAir ?? 0;

      if (category.shippingPriceModeAir == SHIPPING_PRICE_MODE_PER_CBM) {
        totalCost += shippingPrice * totalCBM * exchangeRateValue;
      } else if (category.shippingPriceModeAir == SHIPPING_PRICE_MODE_PER_KG) {
        totalCost += shippingPrice * totalWeight * exchangeRateValue;
      } else if (category.shippingPriceModeAir == SHIPPING_PRICE_MODE_FLAT) {
        totalCost += shippingPrice * item.quantity * exchangeRateValue;
      } else {
        //for air, default to perKg
        totalCost += shippingPrice * totalWeight * exchangeRateValue;
      }
    }

    return {
      "totalCBM": globalTotalCBM,
      "totalWeight": globalTotalWeight,
      "totalCost": totalCost
    };
  }

  Future<Map<String, dynamic>> calculateSeaShippingCost(
      {List<Product> products}) async {
    if (products == null || products.length == 0) {
      return {"totalCBM": 0, "totalWeight": 0, "totalCost": 0};
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
    double globalTotalWeight = 0;

    double totalCost = 0;
    for (var item in products) {
      //item CBM
      double tmpCBM = 0;
      if (item.shippingCBMQuantity != null &&
          item.shippingCBMQuantity > 0 &&
          item.shippingCBMValue != null) {
        tmpCBM = item.shippingCBMValue / item.shippingCBMQuantity;
      } else {
        tmpCBM = Utils.calculateCBM(item.length, item.width, item.height);
      }

      //item weight
      double tmpWeight = 0;
      if (item.shippingWeightQuantity != null &&
          item.shippingWeightQuantity > 0 &&
          item.shippingWeightValue != null) {
        tmpWeight = item.shippingWeightValue / item.shippingWeightQuantity;
      } else {
        tmpWeight = item.weight;
      }

      double totalCBM = tmpCBM * item.quantity;
      double totalWeight = tmpWeight * item.quantity;
      globalTotalCBM += totalCBM;
      globalTotalWeight += totalWeight;

      Category category =
          Category.getCategory(item.categoryId, _categoryService.allCategories);
      double shippingPrice = category?.shippingPriceSea ?? 0;

      if (category.shippingPriceModeSea == SHIPPING_PRICE_MODE_PER_CBM) {
        totalCost += shippingPrice * totalCBM * exchangeRateValue;
      } else if (category.shippingPriceModeSea == SHIPPING_PRICE_MODE_PER_KG) {
        totalCost += shippingPrice * totalWeight * exchangeRateValue;
      } else if (category.shippingPriceModeSea == SHIPPING_PRICE_MODE_FLAT) {
        totalCost += shippingPrice * item.quantity * exchangeRateValue;
      } else {
        //for sea, default to perCBM
        totalCost += shippingPrice * totalCBM * exchangeRateValue;
      }
    }

    return {
      "totalCBM": globalTotalCBM,
      "totalWeight": globalTotalWeight,
      "totalCost": totalCost
    };
  }

  Future<double> calculateSeaShippingCostForProduct(Product item) async {
    if (item == null) {
      return 0;
    }

    //convert shipping price from usd
    double exchangeRateValue = 1;
    String toCurrency = await LangUtils.getSelectedCurrency();
    var exchangeRate = ExchangeRate.getExchangeRate(exchangeRates,
        from: "USD", to: toCurrency);
    if (exchangeRate?.value != null) {
      exchangeRateValue = exchangeRate.value;
    }

    double totalCost = 0;
    //item CBM
    double tmpCBM = 0;
    if (item.shippingCBMQuantity != null &&
        item.shippingCBMQuantity > 0 &&
        item.shippingCBMValue != null) {
      tmpCBM = item.shippingCBMValue / item.shippingCBMQuantity;
    } else {
      tmpCBM = Utils.calculateCBM(item.length, item.width, item.height);
    }

    //item weight
    double tmpWeight = 0;
    if (item.shippingWeightQuantity != null &&
        item.shippingWeightQuantity > 0 &&
        item.shippingWeightValue != null) {
      tmpWeight = item.shippingWeightValue / item.shippingWeightQuantity;
    } else {
      tmpWeight = item.weight;
    }

    double totalCBM = tmpCBM;
    double totalWeight = tmpWeight;

    Category category =
        Category.getCategory(item.categoryId, _categoryService.allCategories);
    double shippingPrice = category?.shippingPriceSea ?? 0;

    if (category?.shippingPriceModeSea == SHIPPING_PRICE_MODE_PER_CBM) {
      totalCost = shippingPrice * totalCBM * exchangeRateValue;
    } else if (category?.shippingPriceModeSea == SHIPPING_PRICE_MODE_PER_KG) {
      totalCost = shippingPrice * totalWeight * exchangeRateValue;
    } else if (category?.shippingPriceModeSea == SHIPPING_PRICE_MODE_FLAT) {
      totalCost = shippingPrice * exchangeRateValue;
    } else {
      //for sea, default to perCBM
      totalCost = shippingPrice * totalCBM * exchangeRateValue;
    }

    return totalCost;
  }

  Future<double> calculateSeaShippingCostForElasticProduct(ElasticProduct item) async {
    if (item == null) {
      return 0;
    }

    //convert shipping price from usd
    double exchangeRateValue = 1;
    String toCurrency = await LangUtils.getSelectedCurrency();
    var exchangeRate = ExchangeRate.getExchangeRate(exchangeRates,
        from: "USD", to: toCurrency);
    if (exchangeRate?.value != null) {
      exchangeRateValue = exchangeRate.value;
    }

    double totalCost = 0;
    //item CBM
    double tmpCBM = 0;
    if (item.shippingCBMQuantity != null &&
        item.shippingCBMQuantity > 0 &&
        item.shippingCBMValue != null) {
      tmpCBM = item.shippingCBMValue / item.shippingCBMQuantity;
    } else {
      tmpCBM = Utils.calculateCBM(item.length, item.width, item.height);
    }

    //item weight
    double tmpWeight = 0;
    if (item.shippingWeightQuantity != null &&
        item.shippingWeightQuantity > 0 &&
        item.shippingWeightValue != null) {
      tmpWeight = item.shippingWeightValue / item.shippingWeightQuantity;
    } else {
      tmpWeight = item.weight;
    }

    double totalCBM = tmpCBM;
    double totalWeight = tmpWeight;

    Category category =
        Category.getCategory(item.categoryId, _categoryService.allCategories);
    double shippingPrice = category?.shippingPriceSea ?? 0;

    if (category?.shippingPriceModeSea == SHIPPING_PRICE_MODE_PER_CBM) {
      totalCost = shippingPrice * totalCBM * exchangeRateValue;
    } else if (category?.shippingPriceModeSea == SHIPPING_PRICE_MODE_PER_KG) {
      totalCost = shippingPrice * totalWeight * exchangeRateValue;
    } else if (category?.shippingPriceModeSea == SHIPPING_PRICE_MODE_FLAT) {
      totalCost = shippingPrice * exchangeRateValue;
    } else {
      //for sea, default to perCBM
      totalCost = shippingPrice * totalCBM * exchangeRateValue;
    }

    return totalCost;
  }
}
