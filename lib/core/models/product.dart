import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/helpers/lang_utils.dart';
import 'package:online_china_app/core/models/translated_model.dart';

class Product extends TranslatedModel {
  String id;
  String type;
  double price;
  String currency;
  String categoryId;
  String quality;
  String sku;

  Product({
    this.id,
    this.type,
    this.price,
    this.currency,
    this.categoryId,
    this.quality,
    this.sku,
  }) : super();

  String get name {
    var lang = LangUtils.getCurrentLocale();
    return getTranslatedValue("name", lang, FALLBACK_LANG);
  }

  String get description {
    var lang = LangUtils.getCurrentLocale();
    return getTranslatedValue("description", lang, FALLBACK_LANG);
  }

  Product.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    id = map['_id'];
    type = map['type'];
    price = map['price'] != null ? double.parse(map['price'].toString()) : 0;
    currency = map['currency'];
    categoryId = map['categoryId'];
    quality = map['quality'];
    sku = map['sku'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['categoryId'] = this.categoryId;
    data['quality'] = this.quality;
    data['sku'] = this.sku;
    data['translations'] = this.translations;
    return data;
  }
}
