import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/models/base_pricing_rule.dart';

class BulkPricingRule extends BasePricingRule {
  double minQuantity;
  double maxQuantity;

  BulkPricingRule({this.minQuantity, this.maxQuantity}) : super();

  BulkPricingRule.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    if (map == null) {
      return;
    }

    minQuantity = map['minQuantity'] != null
        ? double.parse(map['minQuantity'].toString())
        : 0;
    maxQuantity = map['maxQuantity'] != null
        ? double.parse(map['maxQuantity'].toString())
        : MAX_DOUBLE_VAL;
  }

  @override
  double getDiscountedPrice(int quantity, double price) {
    // TODO: implement getDiscountedPrice

    if (quantity == null || quantity <= 0) {
      return -1;
    }

    if (quantity >= minQuantity && quantity <= maxQuantity) {
      if (discountType == DISCOUNT_AMOUNT) {
        if (price == null) {
          return 0;
        }

        return price - amount;
      } else if (discountType == DISCOUNT_PERCENT) {
        if (price == null) {
          return 0;
        }
        return (1 - amount) * price;
      } else if (discountType == DISCOUNT_FIXED_PRICE) {
        return amount;
      } else {
        return amount;
      }
    }

    return -1;
  }
}
