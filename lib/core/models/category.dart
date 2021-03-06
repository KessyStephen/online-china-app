import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/helpers/lang_utils.dart';
import 'package:online_china_app/core/models/translated_model.dart';

class Category extends TranslatedModel {
  String id;
  String parentId;
  List<Category> children;
  double commissionRate;
  double shippingPricePerCBM;

  double shippingPriceSea;
  String shippingPriceModeSea; //perKg, perCBM, flat

  double shippingPriceAir;
  String shippingPriceModeAir; //perKg, perCBM, flat

  Category({
    this.id,
    this.parentId,
  }) : super();

  // cached translations
  String _currentLang;
  String _name;
  String _description;
  String _image;

  String get name {
    var lang = LangUtils.getCurrentLocale();
    // if (_currentLang == lang) {
    //   return _name;
    // }

    _name = getTranslatedValue("name", lang, FALLBACK_LANG);
    _currentLang = lang;
    return _name;
  }

  String get description {
    var lang = LangUtils.getCurrentLocale();
    // if (_currentLang == lang) {
    //   return _description;
    // }

    _description = getTranslatedValue("description", lang, FALLBACK_LANG);
    _currentLang = lang;
    return _description;
  }

  String get image {
    var lang = LangUtils.getCurrentLocale();
    _image = getTranslatedValue("image", lang, FALLBACK_LANG);
    _currentLang = lang;
    return _image;
  }

  Category.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    if (map == null) {
      return;
    }

    id = map['_id'];
    parentId = map['parentId'];
    commissionRate = map['commissionRate'] != null
        ? double.parse(map['commissionRate'].toString())
        : 0;
    shippingPricePerCBM = map['shippingPricePerCBM'] != null
        ? double.parse(map['shippingPricePerCBM'].toString())
        : 0;

    shippingPriceSea = map['shippingPriceSea'] != null
        ? double.parse(map['shippingPriceSea'].toString())
        : 0;

    shippingPriceAir = map['shippingPriceAir'] != null
        ? double.parse(map['shippingPriceAir'].toString())
        : 0;
    shippingPriceModeSea = map['shippingPriceModeSea'];
    shippingPriceModeAir = map['shippingPriceModeAir'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentId'] = this.parentId;
    data['translations'] = this.translations;
    data['commissionRate'] = this.commissionRate;
    data['shippingPricePerCBM'] = this.shippingPricePerCBM;

    data['shippingPriceSea'] = this.shippingPriceSea;
    data['shippingPriceAir'] = this.shippingPriceAir;
    data['shippingPriceModeSea'] = this.shippingPriceModeSea;
    data['shippingPriceModeAir'] = this.shippingPriceModeAir;

    return data;
  }

  static List<Category> getChildren(
      String parentId, List<Category> allCategories) {
    if (allCategories == null || allCategories.length == 0) {
      return null;
    }

    List<Category> results = [];
    allCategories.forEach((element) {
      if (element.parentId == parentId) {
        results.add(element);
      }
    });

    return results;
  }

  static Category getCategory(String id, List<Category> allCategories) {
    if (id == null || allCategories == null || allCategories.length == 0) {
      return null;
    }

    var result;
    for (var element in allCategories) {
      if (element.id == id) {
        result = element;
        break;
      }
    }
    return result;
  }

  static double getCategoryCommissionRate(
      String id, List<Category> allCategories) {
    var category = getCategory(id, allCategories);

    if (category == null) {
      return 0;
    }

    return category.commissionRate ?? 0;
  }
}
