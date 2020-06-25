import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/product_service.dart';

import '../base_model.dart';

class ProductModel extends BaseModel {
  final ProductService _productService;
  ProductModel({@required ProductService productService})
      : _productService = productService;

  List<Product> get products => _productService.products;

  Future<bool> getProducts(
      {categoryIds = "", page = 1, hideLoading = false}) async {
    if (hideLoading) {
      setState(ViewState.Busy);
    }
    bool response =
        await _productService.getProducts(categoryIds: categoryIds, page: page);
    setState(ViewState.Idle);
    return response;
  }
}
