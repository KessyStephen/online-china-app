import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/banner_item.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/models/company_settings.dart';
import 'package:online_china_app/core/models/favorite.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/home_service.dart';

import '../base_model.dart';

class HomeModel extends BaseModel {
  int currentIndex = 0;

  final HomeService _homeService;

  HomeModel({@required HomeService homeService}) : _homeService = homeService;

  List<BannerItem> get banners => _homeService.banners;
  List<Category> get trendingCategories => _homeService.trendingCategories;
  List<Product> get newArrivalProducts => _homeService.newArrivalProducts;
  List<Product> get bestSellingProducts => _homeService.bestSellingProducts;
  List<Product> get recommendedProducts => _homeService.recommendedProducts;

  List<Favorite> get favorites => _homeService.favorites;

  CompanySettings get companySettings => _homeService.companySettings;

  Future<bool> getAllCategories({hideLoading = false}) async {
    if (hideLoading) {
      setState(ViewState.Busy);
    }
    bool response = await _homeService.getAllCategories();
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> getNewArrivalProducts() async {
    setState(ViewState.Busy);
    bool response = await _homeService.getNewArrivalProducts();
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> getBestSellingProducts() async {
    setState(ViewState.Busy);
    bool response = await _homeService.getBestSellingProducts();
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> getFavorites(
      {perPage = PER_PAGE_COUNT, page = 1, hideLoading = false}) async {
    if (!hideLoading) {
      setState(ViewState.Busy);
    }
    bool response =
        await _homeService.getFavorites(perPage: perPage, page: page);
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> getCompanySettings() async {
    setState(ViewState.Busy);
    var response = await _homeService.getCompanySettings();
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> getExchangeRates() async {
    setState(ViewState.Busy);
    var response = await _homeService.getExchangeRates();
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> getHomeItems() async {
    setState(ViewState.Busy);
    var response = await _homeService.getHomeItems();
    setState(ViewState.Idle);
    return response;
  }
}
