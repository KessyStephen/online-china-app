class User {
  int id;
  String name;
  String phone;
  String email;
  bool isLoggedIn;

  User({this.id, this.name, this.phone, this.email, this.isLoggedIn});

  User.initial()
      : id = 0,
        name = '',
        phone = '',
        isLoggedIn = false;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] is String ? int.parse(json['id']) : json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    isLoggedIn = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['is_logged_in'] = true;
    return data;
  }
}
