import 'dart:typed_data';

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
  bool get isSampleRequest => _orderService.isSampleRequest;

  Future<bool> getOrders(
      {perPage = PER_PAGE_COUNT,
      page = 1,
      sort = "",
      hideLoading = false}) async {
    if (!hideLoading) {
      setState(ViewState.Busy);
    }
    bool response =
        await _orderService.getOrders(perPage: perPage, page: page, sort: sort);
    setState(ViewState.Idle);
    return response;
  }

  Future<Order> getOrder({String orderId = "", hideLoading = false}) async {
    if (!hideLoading) {
      setState(ViewState.Busy);
    }
    Order response = await _orderService.getOrder(orderId: orderId);
    setState(ViewState.Idle);
    return response;
  }

  Future<String> getInvoiceHTML({String orderId = ""}) async {
    setState(ViewState.Busy);
    var response = await _orderService.getInvoiceHTML(orderId: orderId);
    setState(ViewState.Idle);
    return response;
  }

  Future<Uint8List> generateInvoicePDF({String htmlContent}) async {
    setState(ViewState.Busy);
    var response =
        await _orderService.generateInvoicePDF(htmlContent: htmlContent);
    setState(ViewState.Idle);
    return response;
  }

  Future<List<String>> createOrder({List<Product> products}) async {
    setState(ViewState.Busy);
    List<String> response = await _orderService.createOrder(products: products);
    setState(ViewState.Idle);
    return response;
  }

  Product getProductFromCart(String productId) {
    return _orderService.getProductFromCart(productId);
  }

  void clearCartData() async {
    _orderService.clearCartData();
  }
}
