import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/category_service.dart';
import 'package:online_china_app/core/services/product_service.dart';

import '../base_model.dart';

class HomeModel extends BaseModel {
  int currentIndex = 0;

  final CategoryService _categoryService;
  final ProductService _productService;
  HomeModel(
      {@required CategoryService categoryService,
      @required ProductService productService})
      : _categoryService = categoryService,
        _productService = productService;

  List<Category> get trendingCategories => _categoryService.trendingCategories;
  List<Product> get newArrivalProducts => _productService.newArrivalProducts;
  List<Product> get bestSellingProducts => _productService.bestSellingProducts;

  Future<bool> getTrendingCategories() async {
    bool response = await _categoryService.getTrendingCategories();
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> getNewArrivalProducts() async {
    bool response = await _productService.getNewArrivalProducts();
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> getBestSellingProducts() async {
    bool response = await _productService.getBestSellingProducts();
    setState(ViewState.Idle);
    return response;
  }

  void navigateToTab(int index) async {
    setState(ViewState.Busy);
    currentIndex = index;
    setState(ViewState.Idle);
  }

  // Future<bool> handleStartUpLogic() async {
  //   setState(ViewState.Busy);
  //   // bool res = await this._startUpService.handleStartUplogic();
  //   setState(ViewState.Idle);
  //   return res;
  // }

  void addUserToStream() {
    setState(ViewState.Busy);
    // _startUpService.addUserToStream();
    setState(ViewState.Idle);
  }
}
