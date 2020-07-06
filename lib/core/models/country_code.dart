class CountryCode {
  String code;
  String country;
  String phonePrefix;

  CountryCode({this.code, this.country, this.phonePrefix});

  CountryCode.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    code = map['code2'];
    country = map['country'];
    phonePrefix = map['phonePrefix'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map();
    data['code'] = this.code;
    data['country'] = this.country;
    data['phonePrefix'] = this.phonePrefix;
    return data;
  }
}
