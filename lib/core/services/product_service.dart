import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/models/product.dart';

import 'alert_service.dart';
import 'api.dart';

class ProductService {
  final Api _api;
  final AlertService _alertService;

  ProductService({@required Api api, @required AlertService alertService})
      : _api = api,
        _alertService = alertService;

  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _searchedProducts = [];
  List<Product> get searchedProducts => _searchedProducts;

  List<Product> _newArrivalProducts = [];
  List<Product> get newArrivalProducts => _newArrivalProducts;

  List<Product> _bestSellingProducts = [];
  List<Product> get bestSellingProducts => _bestSellingProducts;

  Future<bool> getProducts(
      {perPage = PER_PAGE_COUNT, page = 1, sort = ""}) async {
    var response =
        await this._api.getProducts(perPage: perPage, page: page, sort: sort);
    if (response != null && response['success']) {
      var tmpArray = response['data'];

      if (tmpArray.length == 0) {
        return false;
      }

      if (page == 1) {
        _products.clear();
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
}
