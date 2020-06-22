import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:online_china_app/core/viewmodels/views/home_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/category_grid_item.dart';
import 'package:online_china_app/ui/widgets/product_grid_item.dart';
import 'package:online_china_app/ui/widgets/search_bar.dart';
import 'package:provider/provider.dart';

import '../../base_widget.dart';

class HomeTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      model: HomeModel(
          categoryService: Provider.of(context),
          productService: Provider.of(context)),
      onModelReady: (model) {
        model.getTrendingCategories();
        model.getNewArrivalProducts();
        model.getBestSellingProducts();
      },
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  // height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    // borderRadius: BorderRadius.only(
                    //     bottomLeft: Radius.circular(40),
                    //     bottomRight: Radius.circular(40))
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.contain,
                        ),
                        Text(
                          "Online China",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      ]),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(flex: 1, child: SearchBar()),
                          Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey, width: 1.0)),
                              child: IconButton(
                                  icon: Icon(
                                Icons.account_circle,
                                color: primaryColor,
                              )))
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 18, bottom: 10, top: 10),
                        height: 170,
                        // width: 64,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.black54, width: 1.0)),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 170.0,
                            initialPage: 0,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: [1, 2, 3, 4, 5].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration:
                                      BoxDecoration(color: primaryColor),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      if (model.trendingCategories.length > 0)
                        Text("Trending Categories",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      if (model.trendingCategories.length > 0)
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                              itemCount: model.trendingCategories.length,
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return CategoryGridItem(
                                  title: model.trendingCategories[index].name,
                                  imageUrl: "https://onlinechina.co/logo.png",
                                );
                              }),
                        ),
                      if (model.bestSellingProducts.length > 0)
                        Text("Best Selling Products",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      if (model.bestSellingProducts.length > 0)
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                              itemCount: model.bestSellingProducts.length,
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                var product = model.bestSellingProducts[index];
                                return ProductGridItem(
                                  title: product.name,
                                  price: product.priceLabel,
                                  imageUrl: "https://onlinechina.co/logo.png",
                                );
                              }),
                        ),
                      if (model.newArrivalProducts.length > 0)
                        Text("New Arrivals",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      if (model.newArrivalProducts.length > 0)
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                              itemCount: model.newArrivalProducts.length,
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                var product = model.newArrivalProducts[index];
                                return ProductGridItem(
                                  title: product.name,
                                  price: product.priceLabel,
                                  imageUrl: "https://onlinechina.co/logo.png",
                                  onPressed: () => Navigator.pushNamed(
                                      context, "/product_detail",
                                      arguments: product),
                                );
                              }),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
