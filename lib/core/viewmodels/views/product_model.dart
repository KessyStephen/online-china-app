import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/favorite.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/product_service.dart';

import '../base_model.dart';

class ProductModel extends BaseModel {
  final ProductService _productService;
  ProductModel({@required ProductService productService})
      : _productService = productService;

  List<Product> get products => _productService.products;
  List<Product> get searchedProducts => _productService.searchedProducts;

  List<Favorite> get favorites => _productService.favorites;
  bool isSort = false;

//cart
  List<Product> get cartProducts => _productService.cartProducts;
  double get cartTotal => _productService.cartTotal;
  int get cartItemCount => _productService.cartItemCount;
  bool get isSampleRequest => _productService.isSampleRequest;

  Future<bool> getProducts(
      {categoryIds = "",
      page = 1,
      perPage = PER_PAGE_COUNT,
      sort = '',
      hideLoading = false}) async {
    if (!hideLoading) {
      setState(ViewState.Busy);
    }
    bool response = await _productService.getProducts(
        categoryIds: categoryIds, page: page, perPage: perPage, sort: sort);
    setState(ViewState.Idle);
    return response;
  }

  Future<Product> getProduct(
      {String productId = "", hideLoading = false}) async {
    if (!hideLoading) {
      setState(ViewState.Busy);
    }
    Product response = await _productService.getProduct(productId: productId);
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> searchProducts(
      {query = '',
      perPage = PER_PAGE_COUNT,
      page = 1,
      sort = "",
      hideLoading = false}) async {
    if (!hideLoading) {
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

  Future<bool> addToCart(Product product) async {
    setState(ViewState.Busy);
    bool response = await _productService.addToCart(product);
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> removeFromCart(Product product) async {
    setState(ViewState.Busy);
    bool response = await _productService.removeFromCart(product);
    setState(ViewState.Idle);
    return response;
  }

  Product getProductFromCart(String productId) {
    return _productService.getProductFromCart(productId);
  }

  Future<bool> clearCartData() async {
    _productService.clearCartData();
    return true;
  }

  void setSampleRequestOrder(bool val) {
    _productService.setSampleRequestOrder(val);
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

  Future<String> addToFavorites({productId, hideLoading = false}) async {
    if (!hideLoading) {
      setState(ViewState.Busy);
    }
    var response = await _productService.addToFavorites(productId: productId);
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> deleteFromFavorites({favoriteId, hideLoading = false}) async {
    if (!hideLoading) {
      setState(ViewState.Busy);
    }
    bool response =
        await _productService.deleteFromFavorites(favoriteId: favoriteId);
    setState(ViewState.Idle);
    return response;
  }

  void setIsSort(bool flag) {
    this.isSort = flag;
  }
  Future<Favorite> getFavoriteForProduct(
      {productId, hideLoading = false}) async {
    if (!hideLoading) {
      setState(ViewState.Busy);
    }
    Favorite result =
        await _productService.getFavoriteForProduct(productId: productId);

    setState(ViewState.Idle);
    return result;
  }

  // Future<bool> checkIfInFavorites({productId, hideLoading = false}) async {
  //   if (!hideLoading) {
  //     setState(ViewState.Busy);
  //   }
  //   bool result = false;

  //   for (var item in _productService.favorites) {
  //     if (item.product != null && item.product.id == productId) {
  //       result = true;
  //       break;
  //     }
  //   }

  //   setState(ViewState.Idle);
  //   return result;
  // }
}
