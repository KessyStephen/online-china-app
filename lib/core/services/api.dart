import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/models/api_client.dart';
import 'package:online_china_app/core/services/alert_service.dart';
import 'package:online_china_app/core/services/navigation_service.dart';
import 'package:online_china_app/core/services/secure_storage_service.dart';

/// The service responsible for networking requests
class Api {
  final SecureStorageService _storageService;
  final NavigationService _navigationService;
  final AlertService _alertService;

  bool isExpired = false;

  static const endpoint = API_ENDPONT;

  var client;

  Api(
      {SecureStorageService storageService,
      NavigationService navigationService,
      AlertService alertService})
      : _storageService = storageService,
        _navigationService = navigationService,
        _alertService = alertService;

  dynamic createClient() {
    if (client != null) {
      return client;
    }

    client = ApiClient(
        defaultHeaders: {'content-type': 'application/json'},
        endpoint: endpoint,
        navigationService: _navigationService,
        storageService: _storageService);

    return client;
  }

  Uri uriForPath(path, params) {
    return Uri.http('$endpoint', path, params);
    // return Uri.https('$endpoint', path, params);
  }

  Future<Map<String, dynamic>> updatePushToken(
      deviceId, deviceOS, pushToken) async {
    try {
      Map<String, String> params = {
        "deviceId": deviceId,
        "deviceOS": deviceOS,
        "pushToken": pushToken
      };
      String token = await _storageService.getAccessToken();
      var uri = uriForPath("/api/update_push_token", null);

      var response = await http.post(uri,
          body: jsonEncode(params),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      return json.decode(response.body);
    } catch (e) {
      // return e;
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

//duplicate
  Future<Map<String, dynamic>> updatePushTokenForUser(
      {deviceId, deviceOS, pushToken}) async {
    try {
      Map<String, String> params = {
        "deviceId": deviceId,
        "deviceOS": deviceOS,
        "pushToken": pushToken
      };
      var uri = uriForPath("/api/update_push_token", null);
      var response = await http.post(uri, body: jsonEncode(params));
      return json.decode(response.body);
    } catch (e) {
      print(e);
      // return e;
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  // Request OTP
  Future<Map> requestOTP(countryCode, phone, otpFor) async {
    try {
      Map<String, String> map = {
        "phoneNumber": phone,
        "countryCode": countryCode,
        "otpFor": otpFor
      };
      var client = await createClient();
      var uri = uriForPath("/api/generate_otp", null);
      var response = await client.post(uri, body: jsonEncode(map));
      return json.decode(response.body);
    } catch (e) {
      print(e);
      //return e;
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  // Verify OTP
  Future<Map> verifyOtp(code, phone, countryCode, otpFor) async {
    try {
      Map<String, String> map = {
        "phoneNumber": phone,
        "countryCode": countryCode,
        "otpFor": otpFor,
        'code': code
      };
      print(map);
      var client = await createClient();
      var uri = uriForPath("/api/verify_otp", null);
      var response = await client.post(uri, body: jsonEncode(map));
      return json.decode(response.body);
    } catch (e) {
      // return e;
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  // Register User
  Future<Map> registerUser(name, phone, countryCode, password, confirmPassword,
      verificationId) async {
    try {
      Map<String, String> map = {
        'name': name,
        'phoneNumber': phone,
        'countryCode': countryCode,
        'password': password,
        'confirmPassword': confirmPassword,
        'verificationId': verificationId
      };
      var client = await createClient();
      var uri = uriForPath("/api/register", null);
      var response = await client.post(uri, body: jsonEncode(map));
      return json.decode(response.body);
    } catch (e) {
      print(e);
      // return e;
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  // Reset Password
  Future<Map> resetPassword(
      countryCode, phone, password, confirmPassword, verificationId) async {
    try {
      Map<String, String> map = {
        'phoneNumber': phone,
        'countryCode': countryCode,
        'password': password,
        'confirmPassword': confirmPassword,
        'verificationId': verificationId
      };
      var client = await createClient();
      var uri = uriForPath("/api/reset_password", null);
      var response = await client.post(uri, body: jsonEncode(map));
      return json.decode(response.body);
    } catch (e) {
      print(e);
      // return e;
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  // Login
  Future<Map> login(countryCode, phone, password) async {
    try {
      Map<String, String> map = {
        'phoneNumber': phone,
        'countryCode': countryCode,
        'password': password
      };
      var client = await createClient();
      var uri = uriForPath("/api/login", null);
      var response = await client.post(uri, body: jsonEncode(map));
      return json.decode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  Future<Map> getCategories({parentId = "", all = ""}) async {
    Map<String, String> params = {
      'parentId': parentId,
      'all': all,
    };
    var client = createClient();
    params.removeWhere((key, value) => value == null);
    try {
      var uri = uriForPath("/api/categories", params);
      var response = await client.get(uri);
      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  Future<Map> getTrendingCategories() async {
    try {
      var client = createClient();
      var uri = uriForPath("/api/categories_trending", null);
      var response = await client.get(uri);
      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  Future<Map> getProducts(
      {perPage = PER_PAGE_COUNT, page = 1, sort = "", categoryIds = ""}) async {
    try {
      Map<String, String> params = {
        'page': page.toString(),
        'perPage': perPage.toString(),
        'sort': sort,
        'categoryIds': categoryIds
      };
      var client = createClient();
      params.removeWhere((key, value) => value == null);
      var uri = uriForPath("/api/products", params);

      var response = await client.get(uri);
      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  Future<Map> searchProducts(
      {query = "", perPage = PER_PAGE_COUNT, page = 1, sort = ""}) async {
    try {
      Map<String, String> params = {
        "query": query,
        'page': page.toString(),
        'perPage': perPage.toString(),
        'sort': sort,
      };
      var client = createClient();
      params.removeWhere((key, value) => value == null);
      var uri = uriForPath("/api/search", params);

      var response = await client.get(uri);
      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  Future<Map> getNewArrivalProducts() async {
    try {
      var client = createClient();
      var uri = uriForPath("/api/products_new_arrivals", null);

      var response = await client.get(uri);
      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  Future<Map> getBestSellingProducts() async {
    try {
      var client = createClient();
      var uri = uriForPath("/api/products_best_selling", null);

      var response = await client.get(uri);
      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  Future<Map> getCountryCodes() async {
    try {
      var client = createClient();
      var uri = uriForPath("/api/country_codes", null);

      var response = await client.get(uri);
      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }

  Future<Map> getOrders({perPage = PER_PAGE_COUNT, page = 1, sort = ""}) async {
    try {
      Map<String, String> params = {
        'page': page.toString(),
        'perPage': perPage.toString(),
        'sort': sort,
      };
      var client = createClient();
      params.removeWhere((key, value) => value == null);
      var uri = uriForPath("/api/orders", params);

      var response = await client.get(uri);
      return json.decode(response.body);
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': "Something went wrong, please try again later",
      };
    }
  }
}
