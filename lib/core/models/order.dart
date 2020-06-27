class Order {
  String id;
  String supplierId;
  String status;
  String paymentStatus;
  DateTime createdAt;

  Order(
      {this.id,
      this.supplierId,
      this.status,
      this.paymentStatus,
      this.createdAt})
      : super();

  Order.fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    supplierId = map['supplierId'];
    status = map['status'];
    paymentStatus = map['paymentStatus'];
    createdAt = map['createdAt'] != null
        ? DateTime.parse(map['createdAt'].toString())
        : null;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['supplierId'] = this.supplierId;
    data['status'] = this.status;
    data['paymentStatus'] = this.paymentStatus;
    return data;
  }
}
