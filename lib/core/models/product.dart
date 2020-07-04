import 'dart:convert';

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
  int quantity = 0;
  int minOrderQuantity = 0;
  String sku;
  String thumbnail;
  List<ImageItem> images;
  List<AttributeItem> attributes;
  bool canRequestSample;

  Product({
    this.id,
    this.type,
    this.price,
    this.currency,
    this.categoryId,
    this.quality,
    this.quantity,
    this.minOrderQuantity,
    this.sku,
    this.thumbnail,
    this.images,
    this.canRequestSample,
  }) : super();

  String get name {
    var lang = LangUtils.getCurrentLocale();
    return getTranslatedValue("name", lang, FALLBACK_LANG);
  }

  String get description {
    var lang = LangUtils.getCurrentLocale();
    return getTranslatedValue("description", lang, FALLBACK_LANG);
  }

  String get priceLabel {
    return currency + " " + price.toString();
  }

  Product.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    id = map['_id'];
    type = map['type'];
    price = map['price'] != null ? double.parse(map['price'].toString()) : 0;
    currency = map['currency'];
    categoryId = map['categoryId'];
    quality = map['quality'];
    quantity = map['quantity'];
    minOrderQuantity =
        map['minOrderQuantity'] != null ? map['minOrderQuantity'] : 0;
    sku = map['sku'];
    canRequestSample = map['canRequestSample'] == true;

    //images
    var imagesArr = map['images'];
    List<ImageItem> imageItems = [];
    if (imagesArr != null && imagesArr.length > 0) {
      for (var i = 0; i < imagesArr.length; i++) {
        var img = imagesArr[i];
        var imgItem = ImageItem.fromMap(img);
        imageItems.add(imgItem);
      }
    }

    images = imageItems;

    //image thumb
    if (images != null && images.length > 0) {
      var imgItem = images[0];
      thumbnail = imgItem.thumbSrc != null && imgItem.thumbSrc.isNotEmpty
          ? imgItem.thumbSrc
          : imgItem.src;
    }

    //attributes
    var attributesArr = map['attributes'];
    List<AttributeItem> attributeItems = [];
    if (attributesArr != null && attributesArr.length > 0) {
      for (var i = 0; i < attributesArr.length; i++) {
        var attr = attributesArr[i];
        var attrItem = AttributeItem.fromMap(attr);
        attributeItems.add(attrItem);
      }
    }

    attributes = attributeItems;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['categoryId'] = this.categoryId;
    data['quality'] = this.quality;
    data['minOrderQuantity'] = this.minOrderQuantity;
    data['sku'] = this.sku;
    data['translations'] = this.translations;
    data['images'] = this.images;
    return data;
  }
}

class ImageItem {
  String id;
  String src;
  String thumbSrc;
  int position;

  ImageItem({this.id, this.src, this.thumbSrc, this.position}) : super();

  ImageItem.fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    src = map['src'];
    thumbSrc = map['thumbSrc'];
    position =
        map['position'] != null ? int.parse(map['position'].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'src': src,
      'thumbSrc': thumbSrc,
      'position': position,
    };
  }
}

class AttributeItem {
  String name;
  List<dynamic> value;
  String valueString;

  AttributeItem({this.name, this.value}) : super();

  AttributeItem.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    value = map['value'];

    var tmpVal = map['value'];
    if (tmpVal != null && tmpVal is List && tmpVal.length > 0) {
      valueString = tmpVal.join(", ");
    } else {
      valueString = "";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'valueString': valueString,
    };
  }
}
