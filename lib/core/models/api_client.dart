import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:online_china_app/core/services/navigation_service.dart';
import 'package:online_china_app/core/services/secure_storage_service.dart';

class ApiClient extends http.BaseClient {
  final SecureStorageService _storageService;
  final NavigationService _navigationService;
  final String _endpoint;

  final Map<String, String> defaultHeaders;
  http.Client _httpClient = new http.Client();

  ApiClient(
      {this.defaultHeaders,
      SecureStorageService storageService,
      NavigationService navigationService,
      String endpoint})
      : _storageService = storageService,
        _navigationService = navigationService,
        _endpoint = endpoint;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }

  @override
  Future<Response> get(url, {Map<String, String> headers}) async {
    if (headers == null) headers = {};
    headers.addAll(defaultHeaders);
    String accessToken = await _storageService.getAccessToken();
    if (accessToken != null) {
      headers["Authorization"] = 'Bearer $accessToken';
    }

    var response = await _httpClient.get(url, headers: headers);

    if (response.statusCode == 401) {
      bool flag = await this.refreshToken();
      if (flag == true) {
        String accessToken = await _storageService.getAccessToken();
        if (accessToken != null) {
          headers["Authorization"] = 'Bearer $accessToken';
        }
        return _httpClient.get(url, headers: headers);
      }
    }

    return response;
  }

  @override
  Future<Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    if (headers == null) headers = {};
    headers.addAll(defaultHeaders);
    String accessToken = await _storageService.getAccessToken();
    if (accessToken != null) {
      headers["Authorization"] = 'Bearer $accessToken';
    }

    var response = await _httpClient.post(url,
        headers: headers, encoding: encoding, body: body);

    if (response.statusCode == 401) {
      bool flag = await this.refreshToken();
      if (flag == true) {
        String accessToken = await _storageService.getAccessToken();
        if (accessToken != null) {
          headers["Authorization"] = 'Bearer $accessToken';
        }
        return _httpClient.post(url,
            headers: headers, encoding: encoding, body: body);
      }
    }

    return response;
  }

  @override
  Future<Response> patch(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    if (headers == null) headers = {};
    headers.addAll(defaultHeaders);
    String accessToken = await _storageService.getAccessToken();
    if (accessToken != null) {
      headers["Authorization"] = 'Bearer $accessToken';
    }

    var response = await _httpClient.patch(url,
        headers: headers, encoding: encoding, body: body);

    if (response.statusCode == 401) {
      bool flag = await this.refreshToken();
      if (flag == true) {
        String accessToken = await _storageService.getAccessToken();
        if (accessToken != null) {
          headers["Authorization"] = 'Bearer $accessToken';
        }
        return _httpClient.patch(url,
            headers: headers, encoding: encoding, body: body);
      }
    }

    return response;
  }

  @override
  Future<Response> put(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    if (headers == null) headers = {};
    headers.addAll(defaultHeaders);
    String accessToken = await _storageService.getAccessToken();
    if (accessToken != null) {
      headers["Authorization"] = 'Bearer $accessToken';
    }

    var response = await _httpClient.put(url,
        headers: headers, body: body, encoding: encoding);

    if (response.statusCode == 401) {
      bool flag = await this.refreshToken();
      if (flag == true) {
        String accessToken = await _storageService.getAccessToken();
        if (accessToken != null) {
          headers["Authorization"] = 'Bearer $accessToken';
        }
        return _httpClient.put(url,
            headers: headers, body: body, encoding: encoding);
      }
    }

    return response;
  }

  @override
  Future<Response> head(url, {Map<String, String> headers}) async {
    if (headers == null) headers = {};
    headers.addAll(defaultHeaders);
    String accessToken = await _storageService.getAccessToken();
    if (accessToken != null) {
      headers["Authorization"] = 'Bearer $accessToken';
    }

    var response = await _httpClient.head(url, headers: headers);

    if (response.statusCode == 401) {
      bool flag = await this.refreshToken();
      if (flag == true) {
        String accessToken = await _storageService.getAccessToken();
        if (accessToken != null) {
          headers["Authorization"] = 'Bearer $accessToken';
        }
        return _httpClient.head(url, headers: headers);
      }
    }

    return response;
  }

  @override
  Future<Response> delete(url, {Map<String, String> headers}) async {
    if (headers == null) headers = {};
    headers.addAll(defaultHeaders);
    String accessToken = await _storageService.getAccessToken();
    if (accessToken != null) {
      headers["Authorization"] = 'Bearer $accessToken';
    }

    var response = await _httpClient.delete(url, headers: headers);

    if (response.statusCode == 401) {
      bool flag = await this.refreshToken();
      if (flag == true) {
        String accessToken = await _storageService.getAccessToken();
        if (accessToken != null) {
          headers["Authorization"] = 'Bearer $accessToken';
        }
        return _httpClient.delete(url, headers: headers);
      }
    }

    return response;
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      String token = await _storageService.getRefreshToken();
      String accessToken = await _storageService.getAccessToken();

      Map<String, String> map = {'refresh_token': token};
      var uri = Uri.https('$_endpoint', '/api/token');
      var response = await http.post(uri, body: jsonEncode(map), headers: {
        'Authorization': 'Bearer $accessToken',
        'content-type': 'application/json'
      });
      Map<String, dynamic> data = json.decode(response.body);
      if (data != null && data['success'])
        return await _storageService.refreshAccessToken(data['access_token']);
      else {
        await _storageService.clearAllData();
        _navigationService.navigateAndNeverReturn('/login');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
