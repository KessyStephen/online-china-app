class Order {
  String id;
  String referenceId;
  String supplierId;
  String status;
  String paymentStatus;
  double total;
  String currency;
  int itemCount;
  DateTime createdAt;

  Order(
      {this.id,
      this.referenceId,
      this.supplierId,
      this.status,
      this.paymentStatus,
      this.itemCount,
      this.createdAt})
      : super();

  String get priceLabel {
    return currency + " " + total.toStringAsFixed(2);
  }

  Order.fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    referenceId = map['referenceId'] != null ? map['referenceId'] : "";
    supplierId = map['supplierId'];
    status = map['status'];
    paymentStatus = map['paymentStatus'];
    createdAt = map['createdAt'] != null
        ? DateTime.parse(map['createdAt'].toString())
        : null;

    total = map['total'] != null ? double.parse(map['total'].toString()) : 0;
    currency = map['totalCurrency'] != null ? map['totalCurrency'] : "";

    itemCount =
        map['itemCount'] != null ? int.parse(map['itemCount'].toString()) : 0;
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
