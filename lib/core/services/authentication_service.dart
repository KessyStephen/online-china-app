import 'dart:async';

import 'package:online_china_app/core/models/country_code.dart';
import 'package:online_china_app/core/models/user.dart';
import 'package:online_china_app/core/services/secure_storage_service.dart';

import 'alert_service.dart';
import 'api.dart';
import 'navigation_service.dart';

class AuthenticationService {
  final Api _api;
  final SecureStorageService _storageService;
  final NavigationService _navigationService;
  final AlertService _alertService;

  AuthenticationService({
    Api api,
    AlertService alertService,
    SecureStorageService storageService,
    NavigationService navigationService,
  })  : _api = api,
        _alertService = alertService,
        _storageService = storageService,
        _navigationService = navigationService;

  bool _isResetPassword = false;

  bool get resetPassword => _isResetPassword;

  String _phone = '';

  String get phone => _phone;

  String _verificationId = '';

  String get verificationId => _verificationId;

  List<CountryCode> _countryCodes = [];

  List<CountryCode> get countryCodes => _countryCodes;

  List<CountryCode> _searchResults = [];

  List<CountryCode> get searchResults => _searchResults;

  CountryCode _selectedCountryCode;

  CountryCode get selectedCountryCode => _selectedCountryCode;

  StreamController<User> userController = StreamController<User>();

  Stream<User> get user => userController.stream;

  Future<bool> login(String phone, String password) async {
    Map response = await _api.login('TZ', phone, password);
    if (response != null && response['success']) {
      await _storageService.storeUserInformation(
          id: response['id'].toString(),
          name: response['name'],
          accessToken: response['access_token'],
          refreshToken: response['refresh_token'],
          phone: phone);
      return addUserToStream();
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  void setIsResetPassword() {
    _isResetPassword = true;
  }

  void setIsNotResetPassword() {
    _isResetPassword = false;
  }

  void setPhoneNumber(String phone) {
    _phone = phone;
  }

  void setVerificationId(String verificationId) {
    this._verificationId = verificationId;
  }

  Future<bool> requestOtp(phone, otpFor) async {
    Map response = await _api.requestOTP('TZ', phone, otpFor);
    if (response != null &&
        response['success'] != null &&
        response != null &&
        response['success']) {
      return true;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> verifyOtp(code, phone, otpFor) async {

    Map response = await _api.verifyOtp(code, phone, this._selectedCountryCode.code, otpFor);
    if (response != null && response['success']) {
      print(response);
      setVerificationId(response['verificationId']);
      return true;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> registerUser(name, phone, countryCode, password, confirmPassword,
      verificationId) async {
    Map response = await _api.registerUser(
        name, phone, countryCode, password, confirmPassword, verificationId);
    if (response != null && response['success']) {
      return true;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> resetPasswordCall(
      phone, countryCode, password, confirmPassword, verificationId) async {
    if (password != confirmPassword) {
      _alertService.showAlert(
          text: 'Password and confirm password do not match', error: true);
      return false;
    }
    Map response = await _api.resetPassword(
        phone, countryCode, password, confirmPassword, verificationId);
    if (response != null && response['success']) {
      return true;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> getCountryCodes() async {
    Map response = await _api.getCountryCodes();
    if (response != null && response['success']) {
      var countryCodesArray = response['data'];
      for (int i = 0; i < countryCodesArray.length; i++) {
        _countryCodes.add(CountryCode.fromJson(countryCodesArray[i]));
        _searchResults.add(CountryCode.fromJson(countryCodesArray[i]));
        if (CountryCode.fromJson(countryCodesArray[i]).code == 'TZ') {
          _selectedCountryCode = CountryCode.fromJson(countryCodesArray[i]);
        }
      }
      return true;
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> checkIfUserIsLoggedIn() async {
    Map<String, dynamic> userInfo = await _storageService.getUserInformation();
    if (userInfo['id'] != null) {
      return true;
    }
    return false;
  }

  Future<bool> addUserToStream() async {
    Map<String, dynamic> userInfo = await _storageService.getUserInformation();
    if (userInfo['id'] != null)
      userController.add(User.fromJson(userInfo));
    else
      userController.add(User.initial());
    return true;
  }

  void logout() async {
    await _storageService.clearAllData();
    _navigationService.navigateTo('/login');
  }

  void setIsBasketFull(bool isBasketFull) {
//    _storageService.setBasketStatus(isBasketFull);
  }

  Future<bool> checkIfBasketIsFull() async {
    String status = await _storageService.getUserInfo(key: 'basket_status');
    if (status == 'true')
      return true;
    else
      return false;
  }

  void searchCountry(String text) {
    List<CountryCode> data = [];

    _countryCodes.forEach((countryCode) {
      if (countryCode.country.toLowerCase().contains(text.toLowerCase()) ||
          countryCode.code.toLowerCase().contains(text.toLowerCase()) ||
          countryCode.phonePrefix.toLowerCase().contains(text.toLowerCase())) {
        data.add(countryCode);
      }
    });

    _searchResults = data;
  }

  void setCountryCode(CountryCode countryCode) {
    this._selectedCountryCode = countryCode;
  }
}
