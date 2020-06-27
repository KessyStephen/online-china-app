import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
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
}
