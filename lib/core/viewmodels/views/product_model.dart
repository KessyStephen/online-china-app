import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/company_settings.dart';
import 'package:online_china_app/core/models/currency.dart';
import 'package:online_china_app/core/models/elastic_product.dart';
import 'package:online_china_app/core/models/favorite.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/models/suggestion.dart';
import 'package:online_china_app/core/services/product_service.dart';

import '../base_model.dart';

class ProductModel extends BaseModel {
  final ProductService _productService;
  ProductModel({@required ProductService productService})
      : _productService = productService;

  List<Product> get products => _productService.products;
  List<Product> get searchedProducts => _productService.searchedProducts;
  List<ElasticProduct> get elasticProducts => _productService.elasticProducts;

  List<Favorite> get favorites => _productService.favorites;
  bool isSort = false;

  List<Currency> get currencies => _productService.currencies;

  List<Suggestion> suggestions = [];

  bool showProductList = false;

//cart
  List<Product> get cartProducts => _productService.cartProducts;
  double get cartTotal => _productService.cartTotal;
  double get cartTotalWithServiceCharge =>
      _productService.cartTotalWithServiceCharge;
  double get serviceChargeAmount => _productService.serviceChargeAmount;

  int get cartItemCount => _productService.cartItemCount;
  bool get isSampleRequest => _productService.isSampleRequest;

  CompanySettings get companySettings => _productService.companySettings;

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
      sort,
      currency = "",
      String minPrice,
      String maxPrice,
      String minMOQ,
      String maxMOQ,
      categoryIds,
      hideLoading = false}) async {
    if (!hideLoading) {
      setState(ViewState.Busy);
    }
    bool result = await _productService.searchElasticProducts(
        query: query,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minMOQ: minMOQ,
        maxMOQ: maxMOQ,
        perPage: perPage,
        page: page,
        sort: sort);

    this.showProductList = true;
    setState(ViewState.Idle);
    return result;
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

  void setBuyNowOrder(bool val) {
    _productService.setBuyNowOrder(val);
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

  Future<bool> getCurrencies(
      {perPage = PER_PAGE_COUNT, page = 1, hideLoading = false}) async {
    if (!hideLoading) {
      setState(ViewState.Busy);
    }
    bool response = await _productService.getCurrencies();
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

  Future<void> suggest(query) async {
    setState(ViewState.Busy);
    suggestions = await this._productService.getSuggestions(query);
    setState(ViewState.Idle);
  }

  Future<void> toggleShowResults(bool val) {
    this.showProductList = val;
    notifyListeners();
  }
}
