import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/cart_service.dart';

import 'alert_service.dart';
import 'api.dart';

class ProductService {
  final Api _api;
  final AlertService _alertService;
  final CartService _cartService;

  ProductService(
      {@required Api api,
      @required AlertService alertService,
      @required CartService cartService})
      : _api = api,
        _alertService = alertService,
        _cartService = cartService;

  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _searchedProducts = [];
  List<Product> get searchedProducts => _searchedProducts;

  List<Product> _newArrivalProducts = [];
  List<Product> get newArrivalProducts => _newArrivalProducts;

  List<Product> _bestSellingProducts = [];
  List<Product> get bestSellingProducts => _bestSellingProducts;

  Future<bool> getProducts(
      {perPage = PER_PAGE_COUNT, page = 1, sort = "", categoryIds = ""}) async {
    if (page == 1) {
      _products.clear();
    }
    var response = await this._api.getProducts(
        perPage: perPage, page: page, sort: sort, categoryIds: categoryIds);
    if (response != null && response['success']) {
      var tmpArray = response['data'];

      if (tmpArray.length == 0) {
        return false;
      }

      for (int i = 0; i < tmpArray.length; i++) {
        _products.add(Product.fromMap(tmpArray[i]));
      }

      return true;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<Product> getProduct({String productId = ""}) async {
    if (productId == null || productId.isEmpty) {
      return null;
    }

    var response = await this._api.getProduct(productId: productId);
    if (response != null && response['success']) {
      var obj = response['data'];

      if (obj != null) {
        return Product.fromMap(obj);
      }

      return null;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return null;
    }
  }

  Future<bool> searchProducts(
      {query = '', perPage = PER_PAGE_COUNT, page = 1, sort = ""}) async {
    var response = await this
        ._api
        .searchProducts(query: query, perPage: perPage, page: page, sort: sort);

    _searchedProducts.clear();
    if (response != null && response['success']) {
      var tmpArray = response['data'];

      if (tmpArray.length == 0) {
        return false;
      }

      for (int i = 0; i < tmpArray.length; i++) {
        _searchedProducts.add(Product.fromMap(tmpArray[i]));
      }

      return true;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  void clearSearchData() {
    this._searchedProducts.clear();
  }

  Future<bool> getNewArrivalProducts() async {
    var response = await this._api.getNewArrivalProducts();
    if (response != null && response['success']) {
      var tmpArray = response['data'];

      if (tmpArray.length == 0) {
        return false;
      }

      _newArrivalProducts.clear();

      for (int i = 0; i < tmpArray.length; i++) {
        _newArrivalProducts.add(Product.fromMap(tmpArray[i]));
      }

      return true;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> getBestSellingProducts() async {
    var response = await this._api.getBestSellingProducts();
    if (response != null && response['success']) {
      var tmpArray = response['data'];

      if (tmpArray.length == 0) {
        return false;
      }

      _bestSellingProducts.clear();

      for (int i = 0; i < tmpArray.length; i++) {
        _bestSellingProducts.add(Product.fromMap(tmpArray[i]));
      }

      return true;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> addToCart(Product product) async {
    return _cartService.addToCart(product);
  }

  Future<bool> removeFromCart(Product product) async {
    return _cartService.removeFromCart(product);
  }

  void clearCartData() {
    _cartService.clearCartData();
  }
}
