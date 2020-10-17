import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/company_settings.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/cart_service.dart';

import '../base_model.dart';

class CartModel extends BaseModel {
  final CartService _cartService;
  CartModel({@required CartService cartService}) : _cartService = cartService;

  List<Product> get cartProducts => _cartService.cartProducts;
  double get cartTotal => _cartService.cartTotal;
  double get cartTotalWithServiceCharge =>
      _cartService.cartTotalWithServiceCharge;
  double get serviceChargeAmount => _cartService.serviceChargeAmount;

  int get cartItemCount => _cartService.cartItemCount;
  bool get isSampleRequest => _cartService.isSampleRequest;

  String get shippingMethod => _cartService.shippingMethod;
  String get destCountry => _cartService.destCountry;

  double get airShippingCost => _cartService.airShippingCost;
  double get seaShippingCost => _cartService.seaShippingCost;

  CompanySettings get companySettings => _cartService.companySettings;

  Future<bool> addToCart(Product product) async {
    setState(ViewState.Busy);
    bool response = await _cartService.addToCart(product);
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> removeFromCart(Product product) async {
    setState(ViewState.Busy);
    bool response = await _cartService.removeFromCart(product);
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> updateProductInCart(Product product) async {
    setState(ViewState.Busy);
    bool response = await _cartService.updateProductInCart(product);
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> clearCartData() async {
    _cartService.clearCartData();
    return true;
  }

  Future<double> calculateAirShippingCost() async {
    return _cartService.calculateAirShippingCost();
  }

  Future<double> calculateSeaShippingCost() async {
    return _cartService.calculateSeaShippingCost();
  }
}
