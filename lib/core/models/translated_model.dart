class TranslatedModel {
  Map<String, dynamic> translations;
  TranslatedModel({
    this.translations,
  });

  String getTranslatedValue(String key, String lang, String fallbackLang) {
    var val;
    if (translations != null && translations[lang] != null) {
      val = translations[lang][key];
    }

    if (fallbackLang != lang && (val == null || val.toString().isEmpty)) {
      return getTranslatedValue(key, fallbackLang, fallbackLang);
    }
    return val != null ? val : "";
  }

  TranslatedModel.fromMap(Map<String, dynamic> map) {
    if (map != null) {
      translations = map['translations'];
    }
  }
}
