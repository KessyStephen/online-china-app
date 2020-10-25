const double MAX_DOUBLE_VAL = double.maxFinite;

class BasePricingRule {
  String id;
  String ruleType; //bulk, specials etc
  String discountType; // discountAmount, discountPercent, fixedPrice
  double amount;

  BasePricingRule({this.id, this.ruleType, this.discountType, this.amount});

  BasePricingRule.fromMap(Map<String, dynamic> map, double commissionRate,
      double exchangeRate, double seaShippingPrice) {
    if (map == null) {
      return;
    }

    id = map['id'];
    ruleType = map['ruleType'];
    discountType = map['discountType'];
    amount = map['amount'] != null ? double.parse(map['amount'].toString()) : 0;

    //------- price transformations
    //convert amount if exchange rate given
    if (exchangeRate != null) {
      amount = amount * exchangeRate;
    }

    //apply commission
    if (commissionRate != null) {
      var commissionRateFraction = commissionRate / 100;
      amount = (1 + commissionRateFraction) * amount;
    }

    //apply sea shipping
    if (seaShippingPrice != null) {
      amount += seaShippingPrice;
    }
  }

  double getDiscountedPrice(int quantity, double price) {
    return -1;
  }
}
