import 'package:flutter/material.dart';
import 'package:online_china_app/core/viewmodels/views/category_model.dart';
import 'package:online_china_app/ui/base_widget.dart';
import 'package:online_china_app/ui/widgets/category_list_item.dart';
import 'package:provider/provider.dart';

class CategoryTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<CategoryModel>(
      model: CategoryModel(categoryService: Provider.of(context)),
      onModelReady: (model) => model.getCategories(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("Categories")),
        body: SafeArea(
          child: ListView.builder(
              itemCount: model.categories.length,
              shrinkWrap: false,
              itemBuilder: (BuildContext context, int index) {
                return CategoryListItem(
                  title: model.categories[index].name,
                );
              }),
        ),
      ),
    );
  }
}
