import 'package:flutter/material.dart';
import 'package:online_china_app/core/services/account_service.dart';
import 'package:online_china_app/core/viewmodels/base_model.dart';

class AccountModel extends BaseModel {
  final AccountService _accountService;

  AccountModel({@required AccountService accountService})
      : _accountService = accountService;

  void logout() async {
    _accountService.clearData();
  }
}
