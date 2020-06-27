import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/models/order.dart';
import 'package:online_china_app/core/models/product.dart';

import 'alert_service.dart';
import 'api.dart';

class OrderService {
  final Api _api;
  final AlertService _alertService;

  OrderService({@required Api api, @required AlertService alertService})
      : _api = api,
        _alertService = alertService;

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  Future<bool> getOrders(
      {perPage = PER_PAGE_COUNT, page = 1, sort = ""}) async {
    var response =
        await this._api.getOrders(perPage: perPage, page: page, sort: sort);
    if (response != null && response['success']) {
      var tmpArray = response['data'];

      if (tmpArray.length == 0) {
        return false;
      }

      if (page == 1) {
        _orders.clear();
      }

      for (int i = 0; i < tmpArray.length; i++) {
        _orders.add(Order.fromMap(tmpArray[i]));
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

  Future<bool> createOrder({List<Product> products}) async {
    var response = await this._api.createOrder(products: products);
    if (response != null && response['success']) {
      _alertService.showAlert(text: "Order successfully placed", error: false);
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

  void clearOrderData({bool removeOrders = false}) {
    if (removeOrders) this._orders = [];
  }
}
