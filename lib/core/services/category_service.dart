import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/models/category.dart';

import 'alert_service.dart';
import 'api.dart';

class CategoryService {
  final Api _api;
  final AlertService _alertService;

  CategoryService({@required Api api, @required AlertService alertService})
      : _api = api,
        _alertService = alertService;

  List<Category> _allCategories = [];
  List<Category> get allCategories => _allCategories;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  List<Category> _trendingCategories = [];
  List<Category> get trendingCategories => _trendingCategories;

  Future<bool> getAllCategories() async {
    var response = await this._api.getCategories(all: "true");
    if (response != null && response['success']) {
      var categoriesArray = response['data'];

      if (categoriesArray.length == 0) {
        return false;
      }

      _allCategories.clear();

      for (int i = 0; i < categoriesArray.length; i++) {
        _allCategories.add(Category.fromMap(categoriesArray[i]));
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

  Future<bool> getCategories({parentId: String}) async {
    var response = await this._api.getCategories(parentId: parentId);
    if (response != null && response['success']) {
      var categoriesArray = response['data'];

      if (categoriesArray.length == 0) {
        return false;
      }

      _categories.clear();

      for (int i = 0; i < categoriesArray.length; i++) {
        _categories.add(Category.fromMap(categoriesArray[i]));
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

  Future<bool> getTrendingCategories() async {
    var response = await this._api.getTrendingCategories();
    if (response != null && response['success']) {
      var categoriesArray = response['data'];

      return processTrendingCategories(categoriesArray);
    } else {
      _alertService.showAlert(
          text: response != null
              ? response['message']
              : 'It appears you are Offline',
          error: true);
      return false;
    }
  }

  Future<bool> processTrendingCategories(categoriesArray) async {
    if (categoriesArray == null || categoriesArray.length == 0) {
      return false;
    }

    _trendingCategories.clear();

    for (int i = 0; i < categoriesArray.length; i++) {
      _trendingCategories.add(Category.fromMap(categoriesArray[i]));
    }

    return true;
  }
}
