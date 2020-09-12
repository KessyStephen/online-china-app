import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';

class ShippingDetails {
  String shippingMethod = SHIPPING_METHOD_SEA_VALUE;
  double airShippingCost = 0;
  double seaShippingCost = 0;
  double totalWeight = 0;
  double totalCBM = 0;
  String destCountry = "Tanzania";

  ShippingDetails(
      {@required this.shippingMethod,
      @required this.airShippingCost,
      @required this.seaShippingCost,
      @required this.totalWeight,
      @required this.totalCBM,
      @required this.destCountry});

  ShippingDetails.initial()
      : shippingMethod = SHIPPING_METHOD_SEA_VALUE,
        airShippingCost = 0,
        seaShippingCost = 0,
        totalWeight = 0,
        totalCBM = 0,
        destCountry = "Tanzania";
}
