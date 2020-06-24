import 'package:flutter/cupertino.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/services/category_service.dart';

import '../base_model.dart';

class CategoryModel extends BaseModel {
  final CategoryService _categoryService;
  CategoryModel({@required CategoryService categoryService})
      : _categoryService = categoryService;

  List<Category> get categories => _categoryService.categories;
  List<Category> get allCategories => _categoryService.allCategories;

  Future<bool> getAllCategories({hideLoading = false}) async {
    if (hideLoading) {
      setState(ViewState.Busy);
    }
    bool response = await _categoryService.getAllCategories();
    setState(ViewState.Idle);
    return response;
  }

  Future<bool> getCategories({parentId, hideLoading = false}) async {
    if (hideLoading) {
      setState(ViewState.Busy);
    }
    bool response = await _categoryService.getCategories(parentId: parentId);
    setState(ViewState.Idle);
    return response;
  }
}
