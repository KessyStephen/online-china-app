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

  List<Product> _products = [];
  List<Product> get products => _products;

  double get total {
    var sum = 0.0;
    _products.forEach((element) {
      sum = sum + element.price * element.quantity;
    });

    return sum;
  }

  Future<bool> addToCart(Product product) async {
    var found = _products.firstWhere((item) => item.id == product.id,
        orElse: () => null);

    if (found != null) {
      found.quantity = found.quantity + 1;
      return true;
    }

    product.quantity = 1;
    _products.add(product);

    return true;
  }

  Future<bool> removeFromCart(Product product) async {
    var found = _products.firstWhere((item) => item.id == product.id,
        orElse: () => null);

    if (found != null) {
      found.quantity = found.quantity - 1;

      if (found.quantity < 0) {
        _products.removeWhere((item) => item.id == product.id);
      }

      return true;
    }

    return false;
  }

  void clearCart() {
    this._products.clear();
  }
}
