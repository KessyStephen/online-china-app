import 'package:flutter/material.dart';
import 'package:online_china_app/core/viewmodels/views/category_model.dart';
import 'package:online_china_app/ui/views/base_view.dart';
import 'package:online_china_app/ui/widgets/category_grid_item.dart';
import 'package:provider/provider.dart';

class CategoryRow extends StatelessWidget {
  final String title;

  const CategoryRow({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CategoryModel>(
        model: CategoryModel(categoryService: Provider.of(context)),
        onModelReady: (model) => model.getTrendingCategories(),
        builder: (context, model, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (model.trendingCategories.length > 0 && this.title != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(this.title,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  ),
                if (model.trendingCategories.length > 0)
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                        itemCount: model.trendingCategories.length,
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          var category = model.trendingCategories[index];
                          return CategoryGridItem(
                            title: category.name,
                            imageUrl: category.image,
                            onPressed: () {
                              Navigator.pushNamed(context, "/product_list",
                                  arguments: {"parentCategory": category});
                            },
                          );
                        }),
                  ),
              ],
            ));
  }
}
