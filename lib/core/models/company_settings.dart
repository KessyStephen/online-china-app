class CompanySettings {
  double commissionRate;
  double shippingPricePerKg;
  String estimatedDeliveryTimeByAir;
  String estimatedDeliveryTimeByShip;

  CompanySettings(
      {this.commissionRate,
      this.shippingPricePerKg,
      this.estimatedDeliveryTimeByAir,
      this.estimatedDeliveryTimeByShip});

  CompanySettings.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    commissionRate = map['commissionRate'] != null
        ? double.parse(map['commissionRate'].toString())
        : 0;
    shippingPricePerKg = map['shippingPricePerKg'] != null
        ? double.parse(map['shippingPricePerKg'].toString())
        : 0;

    estimatedDeliveryTimeByAir = map['estimatedDeliveryTimeByAir'];
    estimatedDeliveryTimeByShip = map['estimatedDeliveryTimeByShip'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map();
    data['commissionRate'] = this.commissionRate;
    data['shippingPricePerKg'] = this.shippingPricePerKg;
    data['estimatedDeliveryTimeByAir'] = this.estimatedDeliveryTimeByAir;
    data['estimatedDeliveryTimeByShip'] = this.estimatedDeliveryTimeByShip;

    return data;
  }
}
