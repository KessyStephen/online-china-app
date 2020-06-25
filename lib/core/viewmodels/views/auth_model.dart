import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/country_code.dart';
import 'package:online_china_app/core/services/authentication_service.dart';

import '../base_model.dart';

class AuthModel extends BaseModel {
  AuthenticationService _authenticationService;

  AuthModel({
    @required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  String errorMessage;

  bool get isResetPassword => _authenticationService.resetPassword;

  String get phone => _authenticationService.phone;

  String get verificationId => _authenticationService.verificationId;

  List<CountryCode> get countryCodes => _authenticationService.countryCodes;

  List<CountryCode> get searchResults => _authenticationService.searchResults;

  CountryCode get countryCode => _authenticationService.selectedCountryCode;

  void setResetPasswordFlag() => _authenticationService.setIsResetPassword();

  void setNotResetPasswordFlag() =>
      _authenticationService.setIsNotResetPassword();

  Future<bool> login({phone: String, password: String}) async {
    setState(ViewState.Busy);
    var success = await _authenticationService.login(phone, password);
    setState(ViewState.Idle);
    return success;
  }

  Future<bool> requestOtp({String phone, otpFor = 'REGISTER'}) async {
    setState(ViewState.Busy);

    var success = await _authenticationService.requestOtp(phone, otpFor);
    setState(ViewState.Idle);
    return success;
  }

  Future<bool> verifyOtp({code: String, otpFor: String}) async {
    setState(ViewState.Busy);

    var success =
        await _authenticationService.verifyOtp(code, phone, otpFor);
    setState(ViewState.Idle);
    return success;
  }

  Future<bool> resetPassword(
      {phone: String,
      countryCode: String,
      password: String,
      confirmPassword: String,
      verificationId: String}) async {
    setState(ViewState.Busy);

    var success = await _authenticationService.resetPasswordCall(
        phone, countryCode, password, confirmPassword, verificationId);
    setState(ViewState.Idle);
    return success;
  }

  Future<bool> register(
      {name: String,
      phone: String,
      countryCode: String,
      password: String,
      confirmPassword: String,
      verificationId: String}) async {
    setState(ViewState.Busy);

    var success = await _authenticationService.registerUser(
        name, phone, countryCode, password, confirmPassword, verificationId);
    setState(ViewState.Idle);
    return success;
  }

  Future<bool> getCountryCodes() async {
    setState(ViewState.Busy);
    bool success = await _authenticationService.getCountryCodes();
    setState(ViewState.Idle);
    return success;
  }

  searchForCountry(String text) async {
    setState(ViewState.Busy);
    _authenticationService.searchCountry(text);
    setState(ViewState.Idle);
  }

  void setPhoneNumber(String phone) {
    _authenticationService.setPhoneNumber(phone);
    notifyListeners();
  }

  void setIsBasketFull(bool isBasketFull) {
    _authenticationService.setIsBasketFull(isBasketFull);
  }

  Future<bool> checkIfBasketIsFull() async {
    return await _authenticationService.checkIfBasketIsFull();
  }

  void setCountryCode(CountryCode countryCode) {
    setState(ViewState.Busy);
    _authenticationService.setCountryCode(countryCode);
    setState(ViewState.Idle);
  }
}
