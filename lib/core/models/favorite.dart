import 'package:online_china_app/core/models/product.dart';

class Favorite {
  String id;
  Product product;
  DateTime createdAt;

  Favorite({this.id, this.product, this.createdAt});

  Favorite.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    id = map['id'];

    createdAt = map['createdAt'] != null
        ? DateTime.parse(map['createdAt'].toString()).toLocal()
        : null;

    //product
    if (map["product"] != null) {
      product = Product.fromMap(map["product"], null, null, null);
    }
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map();
    data['id'] = this.id;
    data['product'] = this.product.toMap();
    return data;
  }
}
