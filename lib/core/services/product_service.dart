import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/helpers/lang_utils.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/models/company_settings.dart';
import 'package:online_china_app/core/models/currency.dart';
import 'package:online_china_app/core/models/elastic_product.dart';
import 'package:online_china_app/core/models/exchange_rate.dart';
import 'package:online_china_app/core/models/favorite.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/models/suggestion.dart';
import 'package:online_china_app/core/services/cart_service.dart';
import 'package:online_china_app/core/services/category_service.dart';
import 'package:online_china_app/core/services/exchange_rate_service.dart';
import 'package:online_china_app/core/services/favorite_service.dart';

import 'alert_service.dart';
import 'api.dart';

class ProductService {
  final Api _api;
  final AlertService _alertService;
  final CartService _cartService;
  final FavoriteService _favoriteService;
  final CategoryService _categoryService;
  final ExchangeRateService _exchangeRateService;

  ProductService({
    @required Api api,
    @required AlertService alertService,
    @required CartService cartService,
    @required FavoriteService favoriteService,
    @required CategoryService categoryService,
    @required ExchangeRateService exchangeRateService,
  })  : _api = api,
        _alertService = alertService,
        _cartService = cartService,
        _favoriteService = favoriteService,
        _categoryService = categoryService,
        _exchangeRateService = exchangeRateService;

  List<Category> get allCategories => _categoryService.allCategories;

  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _searchedProducts = [];
  List<Product> get searchedProducts => _searchedProducts;

  List<ElasticProduct> _elasticProducts = [];
  List<ElasticProduct> get elasticProducts => _elasticProducts;

  List<Product> _newArrivalProducts = [];
  List<Product> get newArrivalProducts => _newArrivalProducts;

  List<Product> _bestSellingProducts = [];
  List<Product> get bestSellingProducts => _bestSellingProducts;

  List<Product> _recommendedProducts = [];
  List<Product> get recommendedProducts => _recommendedProducts;

  //favorites
  List<Favorite> get favorites => _favoriteService.favorites;

//currencies
  List<Currency> _currencies = [];
  List<Currency> get currencies => _currencies;

  List<Product> get cartProducts => _cartService.cartProducts;
  double get cartTotal => _cartService.cartTotal;
  double get cartTotalWithServiceCharge =>
      _cartService.cartTotalWithServiceCharge;
  double get serviceChargeAmount => _cartService.serviceChargeAmount;

  int get cartItemCount => _cartService.cartItemCount;
  bool get isSampleRequest => _cartService.isSampleRequest;

  CompanySettings get companySettings => _cartService.companySettings;

  List<ExchangeRate> get exchangeRates => _exchangeRateService.exchangeRates;

  Future<bool> getExchangeRates() async {
    return _exchangeRateService.getExchangeRates();
  }

  Future<bool> processExchangeRates(data) async {
    return _exchangeRateService.processExchangeRates(data);
  }

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

      String toCurrency = await LangUtils.getSelectedCurrency();
      for (int i = 0; i < tmpArray.length; i++) {
        var tmp = tmpArray[i];
        if (tmp != null) {
          double commissionRate = Category.getCategoryCommissionRate(
              tmp["categoryId"], allCategories);

          //shipping calculation
          var tmpProd = Product.fromMap(
              tmp, commissionRate, exchangeRates, toCurrency, null);
          double seaShippingPrice = await _cartService?.shippingService
              ?.calculateSeaShippingCostForProduct(tmpProd);

          _products.add(Product.fromMap(tmp, commissionRate, exchangeRates,
              toCurrency, seaShippingPrice));
        }
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
        String toCurrency = await LangUtils.getSelectedCurrency();
        double commissionRate = Category.getCategoryCommissionRate(
            obj["categoryId"], allCategories);

        //shipping calculation
        var tmpProd = Product.fromMap(
            obj, commissionRate, exchangeRates, toCurrency, null);
        double seaShippingPrice = await _cartService?.shippingService
            ?.calculateSeaShippingCostForProduct(tmpProd);

        return Product.fromMap(
            obj, commissionRate, exchangeRates, toCurrency, seaShippingPrice);
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
      {query = '',
      minPrice,
      maxPrice,
      currency = "",
      minMOQ,
      maxMOQ,
      categoryIds,
      perPage = PER_PAGE_COUNT,
      page = 1,
      sort = ""}) async {
    var response = await this._api.searchProducts(
        query: query,
        minPrice: minPrice,
        maxPrice: maxPrice,
        currency: currency,
        minMOQ: minMOQ,
        maxMOQ: maxMOQ,
        categoryIds: categoryIds,
        perPage: perPage,
        page: page,
        sort: sort);

    if (page == 1) {
      _searchedProducts.clear();
    }
    if (response != null && response['success']) {
      var tmpArray = response['data'];

      if (tmpArray.length == 0) {
        return false;
      }

      String toCurrency = await LangUtils.getSelectedCurrency();
      for (int i = 0; i < tmpArray.length; i++) {
        var tmp = tmpArray[i];
        if (tmp != null) {
          double commissionRate = Category.getCategoryCommissionRate(
              tmp["categoryId"], allCategories);

          //shipping calculation
          var tmpProd = Product.fromMap(
              tmp, commissionRate, exchangeRates, toCurrency, null);
          double seaShippingPrice = await _cartService?.shippingService
              ?.calculateSeaShippingCostForProduct(tmpProd);

          _searchedProducts.add(Product.fromMap(tmp, commissionRate,
              exchangeRates, toCurrency, seaShippingPrice));
        }
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
    this._elasticProducts.clear();
  }

  Future<bool> getNewArrivalProducts() async {
    var response = await this._api.getNewArrivalProducts();
    if (response != null && response['success']) {
      var tmpArray = response['data'];

      return processNewArrivalProducts(tmpArray);
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> processNewArrivalProducts(tmpArray) async {
    if (tmpArray == null || tmpArray.length == 0) {
      return false;
    }

    _newArrivalProducts.clear();

    String toCurrency = await LangUtils.getSelectedCurrency();
    for (int i = 0; i < tmpArray.length; i++) {
      var tmp = tmpArray[i];
      if (tmp != null) {
        double commissionRate = Category.getCategoryCommissionRate(
            tmp["categoryId"], allCategories);

        //shipping calculation
        var tmpProd = Product.fromMap(
            tmp, commissionRate, exchangeRates, toCurrency, null);
        double seaShippingPrice = await _cartService?.shippingService
            ?.calculateSeaShippingCostForProduct(tmpProd);
        _newArrivalProducts.add(Product.fromMap(
            tmp, commissionRate, exchangeRates, toCurrency, seaShippingPrice));
      }
    }

    return true;
  }

  Future<List<Product>> getRecommendedProducts(
      {perPage = PER_PAGE_COUNT, page = 1}) async {
    var response =
        await this._api.getRecommendedProducts(page: page, perPage: perPage);
    if (response != null && response['success']) {
      var tmpArray = response['data'];

      return processRecommendedProducts(tmpArray, page: page);
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return null;
    }
  }

  Future<List<Product>> processRecommendedProducts(tmpArray, {page = 1}) async {
    if (tmpArray == null || tmpArray.length == 0) {
      return null;
    }

    if (page == 1) {
      _recommendedProducts.clear();
    }

    List<Product> currentResults = [];

    String toCurrency = await LangUtils.getSelectedCurrency();
    for (int i = 0; i < tmpArray.length; i++) {
      var tmp = tmpArray[i];
      if (tmp != null) {
        double commissionRate = Category.getCategoryCommissionRate(
            tmp["categoryId"], allCategories);

        //shipping calculation
        var tmpProd = Product.fromMap(
            tmp, commissionRate, exchangeRates, toCurrency, null);
        double seaShippingPrice = await _cartService?.shippingService
            ?.calculateSeaShippingCostForProduct(tmpProd);

        var tmpProduct = Product.fromMap(
            tmp, commissionRate, exchangeRates, toCurrency, seaShippingPrice);
        _recommendedProducts.add(tmpProduct);
        currentResults.add(tmpProduct);
      }
    }

    return currentResults;
  }

  Future<bool> getBestSellingProducts() async {
    var response = await this._api.getBestSellingProducts();
    if (response != null && response['success']) {
      var tmpArray = response['data'];

      return processBestSellingProducts(tmpArray);
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> processBestSellingProducts(tmpArray) async {
    if (tmpArray == null || tmpArray.length == 0) {
      return false;
    }

    _bestSellingProducts.clear();

    String toCurrency = await LangUtils.getSelectedCurrency();
    for (int i = 0; i < tmpArray.length; i++) {
      var tmp = tmpArray[i];

      if (tmp != null) {
        double commissionRate = Category.getCategoryCommissionRate(
            tmp["categoryId"], allCategories);

        //shipping calculation
        var tmpProd = Product.fromMap(
            tmp, commissionRate, exchangeRates, toCurrency, null);
        double seaShippingPrice = await _cartService?.shippingService
            ?.calculateSeaShippingCostForProduct(tmpProd);

        _bestSellingProducts.add(Product.fromMap(
            tmp, commissionRate, exchangeRates, toCurrency, seaShippingPrice));
      }
    }

    return true;
  }

  Future<bool> getCurrencies() async {
    var response = await this._api.getCurrencies();
    if (response != null && response['success']) {
      var tmpArray = response['data'];

      if (tmpArray.length == 0) {
        return false;
      }

      _currencies.clear();

      for (int i = 0; i < tmpArray.length; i++) {
        _currencies.add(Currency.fromJson(tmpArray[i]));
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

  Future<bool> getFavorites({perPage = PER_PAGE_COUNT, page = 1}) async {
    return _favoriteService.getFavorites();
  }

  Future<String> addToFavorites({productId}) async {
    return _favoriteService.addToFavorites(productId: productId);
  }

  Future<bool> deleteFromFavorites({favoriteId}) async {
    return _favoriteService.deleteFromFavorites(favoriteId: favoriteId);
  }

  Future<Favorite> getFavoriteForProduct({productId}) async {
    return _favoriteService.getFavoriteForProduct(productId: productId);
  }

  Product getProductFromCart(String productId) {
    return _cartService.getProductFromCart(productId);
  }

  void clearCartData() {
    _cartService.clearCartData();
  }

  void setSampleRequestOrder(bool val) {
    _cartService.setSampleRequestOrder(val);
  }

  void setBuyNowOrder(bool val) {
    _cartService.setBuyNowOrder(val);
  }

  // Get suggestions
  Future<List<Suggestion>> getSuggestions(String query) async {
    print(query);
    var response = await this._api.getSuggetions(query: query);
    List<Suggestion> suggestions = [];
    print(response);
    if (response != null && response['results']['documents'] != null) {
      var data = response['results']['documents'];
      for (int i = 0; i < data.length; i++) {
        print(data[i]);
        suggestions.add(Suggestion.fromMap(data[i]));
      }
      return suggestions;
    }
    return suggestions;
  }

  // Search products
  Future<bool> searchElasticProducts(
      {query = '',
      String minPrice,
      String maxPrice,
      String minMOQ,
      String maxMOQ,
      perPage = PER_PAGE_COUNT,
      page = 1,
      sort}) async {
    var response = await this._api.searchElasticProducts(
        query: query,
        minMOQ: minMOQ,
        maxMOQ: maxMOQ,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sort: sort,
        perPage: perPage,
        page: page);

    if (page == 1) {
      _elasticProducts.clear();
    }
    if (response != null && response['results'] != null) {
      var tmpArray = response['results'];

      if (tmpArray.length == 0) {
        return false;
      }

      String toCurrency = await LangUtils.getSelectedCurrency();
      for (int i = 0; i < tmpArray.length; i++) {
        var tmp = tmpArray[i];
        if (tmp != null) {
          double commissionRate = Category.getCategoryCommissionRate(
              tmp["category_id"]['raw'], allCategories);

          //shipping calculation
          var tmpProd = ElasticProduct.fromMap(
              tmp, commissionRate, exchangeRates, toCurrency, null);
          double seaShippingPrice = await _cartService?.shippingService
              ?.calculateSeaShippingCostForElasticProduct(tmpProd);

          _elasticProducts.add(ElasticProduct.fromMap(tmp, commissionRate,
              exchangeRates, toCurrency, seaShippingPrice));
        }
      }

      return true;
    }
    _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
  }
}
