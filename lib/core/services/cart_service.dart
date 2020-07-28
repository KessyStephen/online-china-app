import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
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
      if (element.type == PRODUCT_TYPE_VARIABLE) {
        sum = sum + element.variationsTotalPrice;
      } else {
        sum = sum + element.price * element.quantity;
      }
    });

    return sum;
  }

  int get cartItemCount {
    return _cartProducts.length;
    // var sum = 0;
    // _cartProducts.forEach((element) {
    //   sum = sum + element.quantity;
    // });

    // return sum;
  }

  Future<bool> addToCart(Product product) async {
    //check minimum order quantity
    if (!_isSampleRequest &&
        product.type == PRODUCT_TYPE_SIMPLE &&
        product.quantity < product.minOrderQuantity) {
      _alertService.showAlert(
          text:
              'Minimum order quantity: ' + product.minOrderQuantity.toString(),
          error: true);
      return false;
    }

    if (!_isSampleRequest &&
        product.type == PRODUCT_TYPE_VARIABLE &&
        product.variationsItemCount < product.minOrderQuantity) {
      _alertService.showAlert(
          text:
              'Minimum order quantity: ' + product.minOrderQuantity.toString(),
          error: true);
      return false;
    }

    //-- continue minimum order quantity reached
    var found = _cartProducts.firstWhere((item) => item.id == product.id,
        orElse: () => null);

    if (found != null) {
      var index = _cartProducts.indexOf(found);
      _cartProducts[index] = product;
      _alertService.showAlert(text: 'Added to items', error: false);
      return true;
    }

    _cartProducts.add(product);

    _alertService.showAlert(text: 'Added to items', error: false);
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

  Product getProductFromCart(String productId) {
    return _cartProducts.firstWhere((item) => item.id == productId,
        orElse: () => null);
  }

  void clearCartData() {
    _isSampleRequest = false;
    this._cartProducts.clear();
  }

  void setSampleRequestOrder(bool val) {
    _isSampleRequest = val;
  }
}
