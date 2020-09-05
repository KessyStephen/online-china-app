import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/helpers/lang_utils.dart';
import 'package:online_china_app/core/models/translated_model.dart';

class Category extends TranslatedModel {
  String id;
  String parentId;
  List<Category> children;
  double commissionRate;
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
    commissionRate = map['commissionRate'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentId'] = this.parentId;
    data['translations'] = this.translations;
    data['commissionRate'] = this.commissionRate;
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
