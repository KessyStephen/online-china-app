class BannerItem {
  String id;
  String image;
  String productId;

  BannerItem({this.id, this.image, this.productId});

  BannerItem.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    id = map['_id'];
    image = map['image'];
    productId = map['productId'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map();
    data['id'] = this.id;
    data['image'] = this.image;
    data['productId'] = this.productId;
    return data;
  }
}
