import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/product_service.dart';

import '../base_model.dart';

class ProductModel extends BaseModel {
  final ProductService _productService;
  ProductModel({@required ProductService productService})
      : _productService = productService;

  List<Product> get products => _productService.products;
  List<Product> get searchedProducts => _productService.searchedProducts;

  Future<bool> getProducts(
      {categoryIds = "",
      page = 1,
      perPage = PER_PAGE_COUNT,
      hideLoading = false}) async {
    if (hideLoading) {
      setState(ViewState.Busy);
    }
    bool response = await _productService.getProducts(
        categoryIds: categoryIds, page: page, perPage: perPage);
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> searchProducts(
      {query = '',
      perPage = PER_PAGE_COUNT,
      page = 1,
      sort = "",
      hideLoading = false}) async {
    if (hideLoading) {
      setState(ViewState.Busy);
    }
    bool response = await _productService.searchProducts(
        query: query, perPage: perPage, page: page, sort: sort);
    setState(ViewState.Idle);
    return response;
  }

  void clearSearchData() {
    _productService.clearSearchData();
  }
}
