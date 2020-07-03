import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/viewmodels/views/category_model.dart';
import 'package:online_china_app/ui/base_widget.dart';
import 'package:online_china_app/ui/widgets/category_list_item.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoryTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Category> rootCategories;
    return BaseView<CategoryModel>(
      model: CategoryModel(categoryService: Provider.of(context)),
      onModelReady: (model) async {
        await model.getAllCategories(hideLoading: true);
        rootCategories = Category.getChildren(null, model.allCategories);
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar:
            AppBar(automaticallyImplyLeading: false, title: Text("Categories")),
        body: SafeArea(
          child: model.state == ViewState.Busy
              ? ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) => Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, right: 16, top: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          maxRadius: 24,
                          child: Container(),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 300,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5.0,
                                  ),
                                ],
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text("             "),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              width: 150,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5.0,
                                  ),
                                ],
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text("             "),
                            )
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: rootCategories == null ? 0 : rootCategories.length,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int index) {
                    Category category = rootCategories[index];

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
