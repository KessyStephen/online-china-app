import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/models/company_settings.dart';
import 'package:online_china_app/core/models/order.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/services/cart_service.dart';
import 'package:printing/printing.dart';

import 'alert_service.dart';
import 'api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

class OrderService {
  final Api _api;
  final AlertService _alertService;
  final CartService _cartService;

  OrderService(
      {@required Api api,
      @required AlertService alertService,
      @required CartService cartService})
      : _api = api,
        _alertService = alertService,
        _cartService = cartService;

  List<Order> _orders = [];
  List<Order> get orders => _orders;
  bool get isSampleRequest => _cartService.isSampleRequest;
  int get cartItemCountWithVariations =>
      _cartService.cartItemCountWithVariations;

  String get shippingMethod => _cartService.shippingMethod;
  String get destCountry => _cartService.destCountry;

  double get airShippingCost => _cartService.airShippingCost;
  double get seaShippingCost => _cartService.seaShippingCost;

  CompanySettings get companySettings => _cartService.companySettings;

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

  Future<Order> getOrder({String orderId = ""}) async {
    if (orderId == null || orderId.isEmpty) {
      return null;
    }

    var response = await this._api.getOrder(orderId: orderId);
    if (response != null && response['success']) {
      var obj = response['data'];

      if (obj != null) {
        return Order.fromMap(obj);
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

  Future<bool> updateOrder({String orderId = "", statusCode = ""}) async {
    if (orderId == null || orderId.isEmpty) {
      return false;
    }

    var response =
        await this._api.updateOrder(orderId: orderId, statusCode: statusCode);
    if (response != null && response['success']) {
      _alertService.showAlert(
          text: "Order successfully $statusCode", error: false);
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

  Future<List<String>> createOrder(
      {List<Product> products,
      shippingMethod,
      destCountry,
      destCity,
      destRegion,
      destStreet}) async {
    var response = await this._api.createOrder(
        products: products,
        isSampleRequest: _cartService.isSampleRequest,
        shippingMethod: shippingMethod,
        destCountry: destCountry,
        destCity: destCity,
        destRegion: destRegion,
        destStreet: destStreet);
    if (response != null && response['success']) {
      //_alertService.showAlert(text: "Order successfully placed", error: false);

      var tmpArray = response['data'];

      if (tmpArray == null || tmpArray.length == 0) {
        return [];
      }

      List<String> ids = [];
      for (int i = 0; i < tmpArray.length; i++) {
        ids.add(tmpArray[i]);
      }

      return ids;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return null;
    }
  }

  Future<String> getInvoiceHTML({String orderId = ""}) async {
    if (orderId == null || orderId.isEmpty) {
      return null;
    }

    var response = await this._api.getInvoiceHTML(orderId: orderId);
    if (response != null && response['success']) {
      var html = response['data'];

      if (html != null) {
        return html;
      }

      return "";
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return null;
    }
  }

  Future<Uint8List> generateInvoicePDF({String htmlContent}) async {
    //filename = filename + ".pdf";
    return Printing.convertHtml(
      format: PdfPageFormat.a4,
      html: htmlContent,
    );
  }

  void showAlertMessage({String message, bool error = false}) {
    _alertService.showAlert(text: message, error: error);
  }

  void clearOrderData({bool removeOrders = false}) {
    if (removeOrders) this._orders = [];
  }

  Product getProductFromCart(String productId) {
    return _cartService.getProductFromCart(productId);
  }

  void clearCartData() {
    _cartService.clearCartData();
  }

  Future<void> updateShippingDetails({
    String shippingMethod,
    String destCountry,
  }) async {
    return _cartService.updateShippingDetails(
        shippingMethod: shippingMethod, destCountry: destCountry);
  }
}
