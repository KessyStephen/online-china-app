import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/models/banner_item.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/models/company_settings.dart';
import 'package:online_china_app/core/models/favorite.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/category_service.dart';
import 'package:online_china_app/core/services/product_service.dart';
import 'package:online_china_app/core/services/settings_service.dart';

import 'alert_service.dart';
import 'api.dart';
import 'banner_service.dart';

class HomeService {
  final Api _api;
  final AlertService _alertService;
  final ProductService _productService;
  final CategoryService _categoryService;
  final BannerService _bannerService;
  final SettingsService _settingsService;

  HomeService({
    @required Api api,
    @required AlertService alertService,
    @required ProductService productService,
    @required CategoryService categoryService,
    @required BannerService bannerService,
    @required SettingsService settingsService,
  })  : _api = api,
        _alertService = alertService,
        _productService = productService,
        _categoryService = categoryService,
        _bannerService = bannerService,
        _settingsService = settingsService;

  List<BannerItem> get banners => _bannerService.banners;
  List<Category> get trendingCategories => _categoryService.trendingCategories;

  List<Product> get newArrivalProducts => _productService.newArrivalProducts;
  List<Product> get bestSellingProducts => _productService.bestSellingProducts;

  List<Favorite> get favorites => _productService.favorites;

  CompanySettings get companySettings => _settingsService.companySettings;

  Future<bool> getNewArrivalProducts() async {
    return _productService.getNewArrivalProducts();
  }

  Future<bool> getBestSellingProducts() async {
    return _productService.getBestSellingProducts();
  }

  Future<bool> getFavorites(
      {perPage = PER_PAGE_COUNT, page = 1, hideLoading = false}) async {
    return _productService.getFavorites(perPage: perPage, page: page);
  }

  Future<bool> getCompanySettings() async {
    return _settingsService.getCompanySettings();
  }

  Future<bool> getExchangeRates() async {
    return _productService.getExchangeRates();
  }

  Future<bool> getAllCategories() async {
    return _categoryService.getAllCategories();
  }

  Future<bool> getHomeItems() async {
    var response = await this._api.getHomeItems();

    if (response != null && response['success']) {
      var obj = response['data'];

      if (obj != null) {
        //exchange rates
        if (obj["settings"] != null) {
          _productService
              .processExchangeRates(obj["settings"]["exchangeRates"]);
          _settingsService.processCompanySettings(obj["settings"]);
        }

        _bannerService.processBanners(obj["banners"]);
        _categoryService.processTrendingCategories(obj["trendingCategories"]);
        _productService.processBestSellingProducts(obj["bestSellingProducts"]);
        _productService.processNewArrivalProducts(obj["newArrivalProducts"]);
      }

      return false;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }
}
