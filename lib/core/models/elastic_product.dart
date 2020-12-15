import 'package:online_china_app/core/helpers/utils.dart';
import 'package:online_china_app/core/models/exchange_rate.dart';

class ElasticProduct {
  String id;
  String thumbnail;
  String title;
  double price;
  String categoryId;
  double noDiscountPrice;
  double minOrderQuantity;
  String minOrderUnit;
  String currency;
  String unit;
  double samplePrice;
  String sampleCurrency;

  double maxPrice;
  double minPrice;

  double length;
  double width;
  double height;
  double weight;

  double shippingCBMQuantity;
  double shippingCBMValue;
  double shippingWeightQuantity;
  double shippingWeightValue;

  ElasticProduct(
      {this.id,
      this.thumbnail,
      this.title,
      this.price,
      this.minOrderQuantity,
      this.currency,
      this.unit})
      : super();

  ElasticProduct.fromMap(
    Map<String, dynamic> map,
    double commissionRate,
    List<ExchangeRate> exchangeRates,
    String toCurrency,
    double seaShippingPrice,
  ) {
    if (map == null) return;

    id = map['id']['raw'];
    thumbnail = map['thumbnail']['raw'];
    title = map['title']['raw'];
    minPrice = map['min_price']['raw'];
    maxPrice = map['max_price']['raw'];
    price =
        double.parse(map['price']['raw'] != null ? map['price']['raw'] : "0");
    currency = map['currency']['raw'];
    categoryId = map['category_id']['raw'];
    noDiscountPrice = price;

    unit = map['unit']['raw'];

    minOrderUnit = map['min_order_unit'] != null ? map['min_order_unit']['raw'] : unit;

    minOrderQuantity = map['min_order_quantity']['raw'];
    length = map['length']['raw'] != null
        ? double.parse(map['length']['raw'].toString())
        : 0;
    width = map['width']['raw'] != null
        ? double.parse(map['width']['raw'].toString())
        : 0;
    height = map['height']['raw'] != null
        ? double.parse(map['height']['raw'].toString())
        : 0;
    weight = map['weight']['raw'] != null
        ? double.parse(map['weight']['raw'].toString())
        : 0;

    shippingCBMQuantity = map['shipping_cbm_quantity']['raw'] != null
        ? double.parse(map['shipping_cbm_quantity']['raw'].toString())
        : null;
    shippingCBMValue = map['shipping_cbm_value']['raw'] != null
        ? double.parse(map['shipping_cbm_value']['raw'].toString())
        : null;
    shippingWeightQuantity = map['shipping_weight_quantity']['raw'] != null
        ? double.parse(map['shipping_weight_quantity']['raw'].toString())
        : null;
    shippingWeightValue = map['shipping_weight_value']['raw'] != null
        ? double.parse(map['shipping_weight_value']['raw'].toString())
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
      // var exchangeRateSample = ExchangeRate.getExchangeRate(exchangeRates,
      //     from: sampleCurrency, to: toCurrency);
      // samplePrice = (1 + commissionRateFraction) *
      //     (exchangeRateSample.value * samplePrice);
      // sampleCurrency = exchangeRateSample.to;
    }

    if (seaShippingPrice != null) {
      price += seaShippingPrice;
      noDiscountPrice = price;
      // samplePrice += seaShippingPrice;
    }
  }

  String get priceLabel {
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
}
