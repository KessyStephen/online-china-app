import 'package:flutter/material.dart';
import 'package:online_china_app/core/viewmodels/views/category_model.dart';
import 'package:online_china_app/ui/base_widget.dart';
import 'package:provider/provider.dart';

class CategoryTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<CategoryModel>(
      model: CategoryModel(categoryService: Provider.of(context)),
      onModelReady: (model) =>
          model.getCategories(parentId: "5eda6c2b9e4231344512d05b"),
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: ListView.builder(
              itemCount: model.categories.length,
              shrinkWrap: false,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: FlutterLogo(),
                  title: Text(model.categories[index].name),
                  trailing: Icon(Icons.chevron_right),
                );
              }),
        ),
      ),
    );
  }
}
