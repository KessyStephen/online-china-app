class CompanySettings {
  double commissionRate;
  String estimatedDeliveryTimeByAir;
  String estimatedDeliveryTimeByShip;

  CompanySettings(
      {this.commissionRate,
      this.estimatedDeliveryTimeByAir,
      this.estimatedDeliveryTimeByShip});

  CompanySettings.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    commissionRate = map['commissionRate'];
    estimatedDeliveryTimeByAir = map['estimatedDeliveryTimeByAir'];
    estimatedDeliveryTimeByShip = map['estimatedDeliveryTimeByShip'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map();
    data['commissionRate'] = this.commissionRate;
    data['estimatedDeliveryTimeByAir'] = this.estimatedDeliveryTimeByAir;
    data['estimatedDeliveryTimeByShip'] = this.estimatedDeliveryTimeByShip;

    return data;
  }
}
