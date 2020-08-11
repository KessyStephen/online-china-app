import 'package:online_china_app/core/models/product.dart';

class CompanySettings {
  double commissionRate;

  CompanySettings({this.commissionRate});

  CompanySettings.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    commissionRate = map['commissionRate'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map();
    data['commissionRate'] = this.commissionRate;
    return data;
  }
}
