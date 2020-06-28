import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/viewmodels/views/category_model.dart';
import 'package:online_china_app/ui/base_widget.dart';
import 'package:online_china_app/ui/widgets/category_list_item.dart';
import 'package:provider/provider.dart';

class CategoryTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Category> rootCategories;
    return BaseView<CategoryModel>(
      model: CategoryModel(categoryService: Provider.of(context)),
      onModelReady: (model) async {
        await model.getAllCategories();
        rootCategories = Category.getChildren(null, model.allCategories);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("Categories")),
        body: SafeArea(
          child: ListView.builder(
              itemCount: rootCategories == null ? 0 : rootCategories.length,
              shrinkWrap: false,
              itemBuilder: (BuildContext context, int index) {
                Category category = rootCategories[index];

                return CategoryListItem(
                  title: category.name,
                  imageUrl: category.image,
                  onPressed: () {
                    List<Category> childCategories =
                        Category.getChildren(category.id, model.allCategories);

                    Map<String, dynamic> params = {
                      'childCategories': childCategories,
                      'parentCategory': category,
                    };
                    Navigator.pushNamed(context, '/subcategories',
                        arguments: params);
                  },
                );
              }),
        ),
      ),
    );
  }
}
