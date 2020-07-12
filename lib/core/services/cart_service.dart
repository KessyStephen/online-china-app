import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/models/product.dart';

import 'alert_service.dart';
import 'api.dart';

class CartService {
  final Api _api;
  final AlertService _alertService;

  CartService({@required Api api, @required AlertService alertService})
      : _api = api,
        _alertService = alertService;

  List<Product> _cartProducts = [];
  List<Product> get cartProducts => _cartProducts;

  bool _isSampleRequest = false;
  bool get isSampleRequest => _isSampleRequest;

  double get cartTotal {
    var sum = 0.0;
    _cartProducts.forEach((element) {
      sum = sum + element.price * element.quantity;
    });

    return sum;
  }

  int get cartItemCount {
    var sum = 0;
    _cartProducts.forEach((element) {
      sum = sum + element.quantity;
    });

    return sum;
  }

  Future<bool> addToCart(Product product) async {
    var found = _cartProducts.firstWhere((item) => item.id == product.id,
        orElse: () => null);

    if (found != null) {
      found.quantity = found.quantity + 1;
      return true;
    }

    product.quantity = 1;
    _cartProducts.add(product);

    return true;
  }

  Future<bool> removeFromCart(Product product) async {
    var found = _cartProducts.firstWhere((item) => item.id == product.id,
        orElse: () => null);

    if (found != null) {
      found.quantity = found.quantity - 1;

      if (found.quantity < 0) {
        _cartProducts.removeWhere((item) => item.id == product.id);
      }

      return true;
    }

    return false;
  }

  void clearCartData() {
    _isSampleRequest = false;
    this._cartProducts.clear();
  }

  void setSampleRequestOrder(bool val) {
    _isSampleRequest = val;
  }
}
