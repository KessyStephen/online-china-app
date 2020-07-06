class BannerItem {
  String id;
  String image;

  BannerItem({this.id, this.image});

  BannerItem.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    id = map['_id'];
    image = map['image'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}
