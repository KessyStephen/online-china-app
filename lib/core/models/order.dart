class Order {
  String id;

  Order({
    this.id,
  }) : super();

  Order.fromMap(Map<String, dynamic> map) {
    id = map['_id'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
