import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/cart_service.dart';

import '../base_model.dart';

class CartModel extends BaseModel {
  final CartService _cartService;
  CartModel({@required CartService cartService}) : _cartService = cartService;

  List<Product> get products => _cartService.products;
  double get total => _cartService.total;
  int get itemCount => _cartService.itemCount;

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

  Future<bool> clearCartData() async {
    _cartService.clearCartData();
    return true;
  }
}
