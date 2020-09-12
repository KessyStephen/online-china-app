import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/helpers/lang_utils.dart';
import 'package:online_china_app/core/helpers/utils.dart';
import 'package:online_china_app/core/models/base_pricing_rule.dart';
import 'package:online_china_app/core/models/bulk_pricing_rule.dart';
import 'package:online_china_app/core/models/exchange_rate.dart';
import 'package:online_china_app/core/models/translated_model.dart';

class Product extends TranslatedModel {
  String id;
  String type;
  double noDiscountPrice;
  double price;
  String currency;
  List<BasePricingRule> pricingRules;
  String categoryId;
  String quality;
  // int quantity = 1;
  int _quantity = 1;
  int minOrderQuantity = 0;
  String minOrderUnit;
  String sku;
  String thumbnail;
  List<ImageItem> images;
  List<KeyValueItem> specifications;
  List<AttributeItem> attributes;
  List<Variation> variations;
  double minPrice; //for variable product
  double maxPrice; //for variable product
  bool canRequestSample;
  double samplePrice;
  String sampleCurrency;
  int sampleQuantity;
  String sampleUnit;

//dimensions, cm and kg
  double length;
  double width;
  double height;
  double weight;

  double shippingCBMQuantity;
  double shippingCBMValue;
  double shippingWeightQuantity;
  double shippingWeightValue;

  Product({
    this.id,
    this.type,
    this.price,
    this.currency,
    this.categoryId,
    this.quality,
    // this.quantity,
    this.minOrderQuantity,
    this.sku,
    this.thumbnail,
    this.images,
    this.canRequestSample,
  }) : super();

  int get quantity {
    return _quantity;
  }

  set quantity(int qty) {
    _quantity = qty;

    double tmpPrice = calculateDiscountedPrice();
    if (tmpPrice > 0) {
      price = tmpPrice;
    } else {
      price = noDiscountPrice;
    }
  }

  String get name {
    var lang = LangUtils.getCurrentLocale();
    return getTranslatedValue("name", lang, FALLBACK_LANG);
  }

  String get description {
    var lang = LangUtils.getCurrentLocale();
    return getTranslatedValue("description", lang, FALLBACK_LANG);
  }

  String get priceLabel {
    //variable product
    if (type == PRODUCT_TYPE_VARIABLE &&
        variations != null &&
        variations.length > 0) {
      if (variationsTotalPrice > 0) {
        var tmpPrice = Utils.formatNumber(variationsTotalPrice);
        return "$currency $tmpPrice";
      }

      if (minPrice != null && maxPrice != null && currency != null) {
        if (minPrice == maxPrice) {
          return "$currency ${Utils.formatNumber(minPrice)}";
        }

        return "$currency ${Utils.formatNumber(minPrice)} - ${Utils.formatNumber(maxPrice)}";
      }

      return "";
    }

    //simple product
    if (price != null && currency != null) {
      return currency + " " + Utils.formatNumber(price);
    }

    return "";
  }

  String get minOrderLabel {
    if (minOrderQuantity != null &&
        minOrderQuantity > 0 &&
        minOrderUnit != null) {
      return minOrderQuantity.toString() + " " + minOrderUnit;
    }
    return null;
  }

  String get samplePriceLabel {
    if (canRequestSample) {
      if (samplePrice != null && sampleCurrency != null) {
        return sampleCurrency + " " + Utils.formatNumber(samplePrice);
      }
      return "";
    } else {
      return this.priceLabel;
    }
  }

  int get variationsItemCount {
    if (variations != null && variations.length > 0) {
      int total = 0;

      for (var item in variations) {
        total = total + item.quantity;
      }

      return total;
    }

    return 0;
  }

  double get variationsTotalPrice {
    if (variations != null && variations.length > 0) {
      double total = 0;

      for (var item in variations) {
        total = total + item.quantity * item.price;
      }

      return total;
    }

    return 0;
  }

  void increaseQuantity(int extraQuantity) {
    quantity = quantity + extraQuantity;

    //minimum one item
    if (quantity <= 0) {
      quantity = 1;
    }
  }

  void setQuantity(int newQuantity) {
    quantity = newQuantity;

    //minimum one item
    if (quantity <= 0) {
      quantity = 1;
    }
  }

  void increaseVariationQuantity(int index, int extraQuantity) {
    var variation = variations[index];

    variation.quantity += extraQuantity;
    if (variation.quantity < 0) {
      variation.quantity = 0;
    }

    variations[index] = variation;
  }

  void setVariationQuantity(int index, int newQuantity) {
    var variation = variations[index];

    variation.quantity = newQuantity;
    if (variation.quantity < 0) {
      variation.quantity = 0;
    }

    variations[index] = variation;
  }

  double calculateDiscountedPrice() {
    if (pricingRules != null) {
      for (var rule in pricingRules) {
        var tmpPrice = rule.getDiscountedPrice(quantity, noDiscountPrice);

        if (tmpPrice != null && tmpPrice > 0) {
          return tmpPrice;
        }
      }
    }

    return -1;
  }

  Product.fromMap(Map<String, dynamic> map, double commissionRate,
      List<ExchangeRate> exchangeRates, String toCurrency)
      : super.fromMap(map) {
    if (map == null) {
      return;
    }

    id = map['_id'];
    type = map['type'] != null ? map['type'] : map['productType'];

    // ============= price and currency
    price = map['price'] != null ? double.parse(map['price'].toString()) : 0;
    noDiscountPrice = price;
    currency = map['currency'];
    categoryId = map['categoryId'];
    quality = map['quality'];
    quantity = map['quantity'] != null ? map['quantity'] : 1;
    minOrderQuantity =
        map['minOrderQuantity'] != null ? map['minOrderQuantity'] : 0;
    minOrderUnit = map['minOrderUnit'] != null ? map['minOrderUnit'] : "";
    sku = map['sku'];
    canRequestSample = map['canRequestSample'] == true;
    samplePrice = map['samplePrice'] != null
        ? double.parse(map['samplePrice'].toString())
        : 0;

    sampleCurrency = map['sampleCurrency'];
    sampleQuantity = map['sampleQuantity'];
    sampleUnit = map['sampleUnit'];

    //dimensions
    length = map['length'] != null ? double.parse(map['length'].toString()) : 0;
    width = map['width'] != null ? double.parse(map['width'].toString()) : 0;
    height = map['height'] != null ? double.parse(map['height'].toString()) : 0;
    weight = map['weight'] != null ? double.parse(map['weight'].toString()) : 0;

    shippingCBMQuantity = map['shippingCBMQuantity'] != null
        ? double.parse(map['shippingCBMQuantity'].toString())
        : null;
    shippingCBMValue = map['shippingCBMValue'] != null
        ? double.parse(map['shippingCBMValue'].toString())
        : null;
    shippingWeightQuantity = map['shippingWeightQuantity'] != null
        ? double.parse(map['shippingWeightQuantity'].toString())
        : null;
    shippingWeightValue = map['shippingWeightValue'] != null
        ? double.parse(map['shippingWeightValue'].toString())
        : null;

    var exchangeRate = ExchangeRate.getExchangeRate(exchangeRates,
        from: currency, to: toCurrency);

    if (commissionRate != null && exchangeRate != null) {
      var commissionRateFraction = commissionRate / 100;

      //simple product
      price = (1 + commissionRateFraction) * (exchangeRate.value * price);
      noDiscountPrice = price;
      currency = exchangeRate.to;

      //sample price
      var exchangeRateSample = ExchangeRate.getExchangeRate(exchangeRates,
          from: sampleCurrency, to: toCurrency);
      samplePrice = (1 + commissionRateFraction) *
          (exchangeRateSample.value * samplePrice);
      sampleCurrency = exchangeRateSample.to;
    }
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
    thumbnail = map["thumbnail"];
    if ((thumbnail == null || thumbnail.isEmpty) &&
        images != null &&
        images.length > 0) {
      var imgItem = images[0];
      thumbnail = imgItem.thumbSrc != null && imgItem.thumbSrc.isNotEmpty
          ? imgItem.thumbSrc
          : imgItem.src;
    }

    //specifications
    var specificationsArr = map['specifications'];
    List<KeyValueItem> specificationItems = [];
    if (specificationsArr != null && specificationsArr.length > 0) {
      for (var i = 0; i < specificationsArr.length; i++) {
        var spec = specificationsArr[i];
        var specItem = KeyValueItem.fromMap(spec);
        specificationItems.add(specItem);
      }
    }

    specifications = specificationItems;

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

    //variations
    var variationsArr = map['variations'];
    List<Variation> variationItems = [];
    if (variationsArr != null && variationsArr.length > 0) {
      for (var i = 0; i < variationsArr.length; i++) {
        var varTmp = variationsArr[i];
        var varItem = Variation.fromMap(
            varTmp, commissionRate, exchangeRates, toCurrency);
        variationItems.add(varItem);
      }

      //take currency for variable product
      currency = variationItems[0]?.currency;
    }
    variations = variationItems;

    //min and max price
    if (variations != null && variations.length > 0) {
      var maxValue = variations[0].price;
      var minValue = variations[0].price;

      variations.forEach((e) => {
            if (e.price > maxValue) {maxValue = e.price},
            if (e.price < minValue) {minValue = e.price},
          });

      maxPrice = maxValue;
      minPrice = minValue;
    }

    //pricingRules
    var pricingRulesArr = map['pricingRules'];
    List<BasePricingRule> pricingRulesItems = [];
    if (pricingRulesArr != null && pricingRulesArr.length > 0) {
      for (var i = 0; i < pricingRulesArr.length; i++) {
        var rule = pricingRulesArr[i];
        if (rule["ruleType"] == PRICING_RULE_TYPE_BULK) {
          var ruleItem = BulkPricingRule.fromMap(rule);
          pricingRulesItems.add(ruleItem);
        }
      }
    }
    pricingRules = pricingRulesItems;
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

  Map<String, dynamic> toMapForAPI() {
    //variable
    if (type == PRODUCT_TYPE_VARIABLE) {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['type'] = this.type;
      data['productId'] = this.id;
      data['variations'] = this.variations;
      return data;
    }

    //simple product
    return {
      'type': this.type,
      'productId': this.id,
      'quantity': this.quantity,
    };
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

class KeyValueItem {
  String name;
  String value;

  KeyValueItem({this.name, this.value}) : super();

  KeyValueItem.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    value = map['value'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

//---- Variations

class Variation {
  String id;
  double noDiscountPrice;
  double price;
  String currency;
  // int quantity = 0;
  int _quantity = 0;

  List<Attribute> attributes;
  List<BasePricingRule> pricingRules;

  int get quantity {
    return _quantity;
  }

  set quantity(int qty) {
    _quantity = qty;

    double tmpPrice = calculateDiscountedPrice();
    if (tmpPrice > 0) {
      price = tmpPrice;
    } else {
      price = noDiscountPrice;
    }
  }

  Variation({this.id, this.price, this.currency}) : super();

  Variation.fromMap(Map<String, dynamic> map, double commissionRate,
      List<ExchangeRate> exchangeRates, String toCurrency) {
    id = map['_id'];
    price = map['price'] != null ? double.parse(map['price'].toString()) : 0;
    noDiscountPrice = price;
    currency = map['currency'];

    var exchangeRate = ExchangeRate.getExchangeRate(exchangeRates,
        from: currency, to: toCurrency);
    if (commissionRate != null && exchangeRate != null) {
      var commissionRateFraction = commissionRate / 100;

      price = (1 + commissionRateFraction) * (exchangeRate.value * price);
      noDiscountPrice = price;
      currency = exchangeRate.to;
    }

    //attributes
    var attributesArr = map['attributes'];
    List<Attribute> attributeItems = [];
    if (attributesArr != null && attributesArr.length > 0) {
      for (var i = 0; i < attributesArr.length; i++) {
        var attr = attributesArr[i];
        var attrItem = Attribute.fromMap(attr);
        attributeItems.add(attrItem);
      }
    }
    attributes = attributeItems;

    //pricingRules
    var pricingRulesArr = map['pricingRules'];
    List<BasePricingRule> pricingRulesItems = [];
    if (pricingRulesArr != null && pricingRulesArr.length > 0) {
      for (var i = 0; i < pricingRulesArr.length; i++) {
        var rule = pricingRulesArr[i];
        if (rule["ruleType"] == PRICING_RULE_TYPE_BULK) {
          var ruleItem = BulkPricingRule.fromMap(rule);
          pricingRulesItems.add(ruleItem);
        }
      }
    }
    pricingRules = pricingRulesItems;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'currency': currency,
      'attributes': attributes,
      'quantity': quantity,
    };
  }

  String get priceLabel {
    if (price != null && currency != null) {
      return currency + " " + Utils.formatNumber(price);
    }

    return "";
  }

  String get attributesLabel {
    if (attributes != null) {
      var label = "";
      attributes.forEach((obj) {
        if (obj?.value != null) {
          label += " | " + obj.value;
        }
      });

      return label;
    }

    return "";
  }

  double calculateDiscountedPrice() {
    if (pricingRules != null) {
      for (var rule in pricingRules) {
        var tmpPrice = rule.getDiscountedPrice(quantity, noDiscountPrice);

        if (tmpPrice != null && tmpPrice > 0) {
          return tmpPrice;
        }
      }
    }

    return -1;
  }
}

class Attribute {
  String name;
  String value;

  // List<String> keys;
  // List<dynamic> values;

  Attribute({this.name, this.value}) : super();

  Attribute.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    value = map['value'];

    // if (map != null && map.keys != null) {
    //   keys = map.keys.toList();
    // }

    // if (map != null && map.values != null) {
    //   values = map.values.toList();
    // }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }

  // String get valuesLabel {
  //   if (values != null) {
  //     return values.join(" | ");
  //   }

  //   return "";
  // }
}
