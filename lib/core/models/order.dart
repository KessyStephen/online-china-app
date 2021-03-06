import 'package:online_china_app/core/helpers/utils.dart';
import 'package:online_china_app/core/models/order_item.dart';

class Order {
  String id;
  String referenceId;
  String supplierId;
  String status;
  String paymentStatus;
  double total;
  String currency;
  double totalWithServiceCharge;
  double serviceChargeAmount;
  double serviceChargePercent;

  int itemCount;
  List<OrderItem> products;
  DateTime createdAt;

  Order(
      {this.id,
      this.referenceId,
      this.supplierId,
      this.status,
      this.paymentStatus,
      this.itemCount,
      this.products,
      this.createdAt})
      : super();

  String get priceLabel {
    return currency + " " + Utils.formatNumber(totalWithServiceCharge);
  }

  Order.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    id = map['_id'];
    referenceId = map['referenceId'] != null ? map['referenceId'] : "";
    supplierId = map['supplierId'];
    status = map['status'];
    paymentStatus = map['paymentStatus'];
    createdAt = map['createdAt'] != null
        ? DateTime.parse(map['createdAt'].toString()).toLocal()
        : null;

    total = map['total'] != null ? double.parse(map['total'].toString()) : 0;
    currency = map['totalCurrency'] != null ? map['totalCurrency'] : "";

    itemCount =
        map['itemCount'] != null ? int.parse(map['itemCount'].toString()) : 0;

    //items
    List<OrderItem> resultItems = [];
    var items = map["items"];
    if (items != null && items.length > 0) {
      for (var i = 0; i < items.length; i++) {
        var obj = items[i];
        var prod = OrderItem.fromMap(obj);
        prod.id = obj["productId"];

        resultItems.add(prod);
      }
    }
    products = resultItems;

    serviceChargeAmount = map['serviceChargeAmount'] != null
        ? double.parse(map['serviceChargeAmount'].toString())
        : 0;
    totalWithServiceCharge = map['totalWithServiceCharge'] != null
        ? double.parse(map['totalWithServiceCharge'].toString())
        : total;

    serviceChargePercent = map['serviceChargePercent'] != null
        ? double.parse(map['serviceChargePercent'].toString())
        : 0;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['referenceId'] = this.referenceId;
    data['supplierId'] = this.supplierId;
    data['status'] = this.status;
    data['total'] = this.total;
    data['totalCurrency'] = this.currency;
    data['paymentStatus'] = this.paymentStatus;
    data['itemCount'] = this.itemCount;

    return data;
  }
}
