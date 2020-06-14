import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/helpers/lang_utils.dart';
import 'package:online_china_app/core/models/translated_model.dart';

class Category extends TranslatedModel {
  String id;
  String parentId;
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
    id = map['_id'];
    parentId = map['parentId'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentId'] = this.parentId;
    data['translations'] = this.translations;
    return data;
  }
}
