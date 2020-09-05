import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/viewmodels/views/category_model.dart';
import 'package:online_china_app/core/viewmodels/views/home_model.dart';
import 'package:online_china_app/ui/views/base_view.dart';
import 'package:online_china_app/ui/widgets/category_grid_item.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoryRow extends StatelessWidget {
  final String title;

  const CategoryRow({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
        model: HomeModel(homeService: Provider.of(context)),
        // onModelReady: (model) {
        //   if (model.trendingCategories == null ||
        //       model.trendingCategories.length == 0) {
        //     model.getTrendingCategories(hideLoading: true);
        //   }
        // },
        builder: (context, model, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (model.trendingCategories.length > 0 ||
                    model.state == ViewState.Busy)
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: model.state == ViewState.Busy
                        ? Shimmer.fromColors(
                            child: Text(
                              this.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.white)
                        : Text(this.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16)),
                  ),
                if (model.trendingCategories.length > 0 ||
                    model.state == ViewState.Busy)
                  SizedBox(
                    height: 120,
                    child: model.state == ViewState.Busy
                        ? Shimmer.fromColors(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: List.generate(4, (index) {
                                return Container(
                                  width: 86,
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                        child: Container(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          width: 100,
                                          color: Colors.black26,
                                          child: Text("      ")),
                                    ],
                                  ),
                                );
                              }),
                            ),
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.white)
                        : ListView.builder(
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
