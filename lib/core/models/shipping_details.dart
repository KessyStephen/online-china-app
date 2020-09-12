import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';

class ShippingDetails {
  String shippingMethod = SHIPPING_METHOD_SEA_VALUE;
  double airShippingCost = 0;
  double seaShippingCost = 0;
  String destCountry = "Tanzania";

  ShippingDetails(
      {@required this.shippingMethod,
      @required this.airShippingCost,
      @required this.seaShippingCost,
      @required this.destCountry});

  ShippingDetails.initial()
      : shippingMethod = SHIPPING_METHOD_SEA_VALUE,
        airShippingCost = 0,
        seaShippingCost = 0,
        destCountry = "Tanzania";
}
