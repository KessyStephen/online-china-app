import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/company_settings.dart';
import 'package:online_china_app/core/models/favorite.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/product_service.dart';

import '../base_model.dart';

class HomeModel extends BaseModel {
  int currentIndex = 0;

  final ProductService _productService;

  HomeModel({@required ProductService productService})
      : _productService = productService;

  List<Product> get newArrivalProducts => _productService.newArrivalProducts;
  List<Product> get bestSellingProducts => _productService.bestSellingProducts;

  List<Favorite> get favorites => _productService.favorites;

  CompanySettings get companySettings => _productService.companySettings;

  Future<bool> getNewArrivalProducts() async {
    setState(ViewState.Busy);
    bool response = await _productService.getNewArrivalProducts();
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> getBestSellingProducts() async {
    setState(ViewState.Busy);
    bool response = await _productService.getBestSellingProducts();
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> getFavorites(
      {perPage = PER_PAGE_COUNT, page = 1, hideLoading = false}) async {
    if (!hideLoading) {
      setState(ViewState.Busy);
    }
    bool response =
        await _productService.getFavorites(perPage: perPage, page: page);
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> getCompanySettings() async {
    setState(ViewState.Busy);
    var response = await _productService.getCompanySettings();
    setState(ViewState.Idle);
    return response;
  }
}
