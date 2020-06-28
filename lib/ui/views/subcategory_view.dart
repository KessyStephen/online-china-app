import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/viewmodels/views/category_model.dart';
import 'package:online_china_app/ui/widgets/category_list_item.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class SubCategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    List<Category> childCategories =
        params != null ? params['childCategories'] : null;
    Category parentCategory = params != null ? params['parentCategory'] : null;

    return BaseView<CategoryModel>(
        model: CategoryModel(categoryService: Provider.of(context)),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(title: Text(parentCategory.name)),
              body: SafeArea(
                child: ListView.builder(
                    itemCount:
                        childCategories == null ? 0 : childCategories.length,
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) {
                      Category category = childCategories[index];

                      return CategoryListItem(
                        title: category.name,
                        imageUrl: category.image,
                        onPressed: () {
                          List<Category> childCategories = Category.getChildren(
                              category.id, model.allCategories);
                          Map<String, dynamic> params = {
                            'childCategories': childCategories,
                            'parentCategory': category,
                          };

                          //no child categories, navigate to product list
                          if (childCategories == null ||
                              childCategories.length == 0) {
                            Navigator.pushNamed(context, '/product_list',
                                arguments: params);
                            return;
                          }

                          Navigator.pushNamed(context, '/subcategories',
                              arguments: params);
                        },
                      );
                    }),
              ),
            ));
  }
}
