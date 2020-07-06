import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/order.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/order_service.dart';

import '../base_model.dart';

class OrderModel extends BaseModel {
  final OrderService _orderService;
  OrderModel({@required OrderService orderService})
      : _orderService = orderService;

  List<Order> get orders => _orderService.orders;

  Future<bool> getOrders(
      {perPage = PER_PAGE_COUNT,
      page = 1,
      sort = "",
      hideLoading = false}) async {
    if (hideLoading) {
      setState(ViewState.Busy);
    }
    bool response =
        await _orderService.getOrders(perPage: perPage, page: page, sort: sort);
    setState(ViewState.Idle);
    return response;
  }

  Future<Order> getOrder({String orderId = "", hideLoading = false}) async {
    if (hideLoading) {
      setState(ViewState.Busy);
    }
    Order response = await _orderService.getOrder(orderId: orderId);
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> createOrder({List<Product> products}) async {
    setState(ViewState.Busy);
    bool response = await _orderService.createOrder(products: products);
    setState(ViewState.Idle);
    return response;
  }

  void clearCartData() async {
    _orderService.clearCartData();
  }
}
