import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:online_china_app/core/viewmodels/views/home_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/category_row.dart';
import 'package:online_china_app/ui/widgets/product_grid_item.dart';
import 'package:online_china_app/ui/widgets/search_bar.dart';
import 'package:provider/provider.dart';

import '../../base_widget.dart';

class HomeTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      model: HomeModel(productService: Provider.of(context)),
      onModelReady: (model) {
        model.getNewArrivalProducts();
        model.getBestSellingProducts();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  height: 50,
                  child: Image.asset(
                    "assets/images/logo_black.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  // height: 100,
                  color: Color.fromRGBO(238, 52, 34, 1.0),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                child: SearchBar(
                                  backgroundColor: primaryColor,
                                  textColor: Colors.white,
                                  disableTextField: true,
                                ),
                                onTap: () =>
                                    Navigator.pushNamed(context, "/search"),
                              )),
                          Container(
                              height: 50,
                              width: 50,
                              child: IconButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, "/account"),
                                  icon: Icon(
                                    CupertinoIcons.profile_circled,
                                    color: Colors.white,
                                    size: 30,
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
                        // decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius:
                        //         const BorderRadius.all(Radius.circular(16))),
                        // decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     border:
                        //         Border.all(color: Colors.black54, width: 1.0)),
                        child: CarouselSlider(
                          options: CarouselOptions(
                              height: 170.0,
                              initialPage: 0,
                              scrollDirection: Axis.horizontal,
                              viewportFraction: 1.0,
                              enableInfiniteScroll: false,
                              autoPlay: false),
                          items: [1, 2, 3, 4, 5].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      CategoryRow(
                        title: "Trending Categories",
                      ),
                      if (model.bestSellingProducts.length > 0)
                        Text("Best Selling Products",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      if (model.bestSellingProducts.length > 0)
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 180.0,
                            maxHeight: 220.0,
                          ),
                          child: ListView.builder(
                              itemCount: model.bestSellingProducts.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                var product = model.bestSellingProducts[index];
                                return ProductGridItem(
                                  title: product.name,
                                  price: product.priceLabel,
                                  imageUrl: product.thumbnail,
                                  onPressed: () => Navigator.pushNamed(
                                      context, "/product_detail",
                                      arguments: product),
                                );
                              }),
                        ),
                      if (model.newArrivalProducts.length > 0)
                        Text("New Arrivals",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      if (model.newArrivalProducts.length > 0)
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 180.0,
                            maxHeight: 220.0,
                          ),
                          child: ListView.builder(
                              itemCount: model.newArrivalProducts.length,
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                var product = model.newArrivalProducts[index];
                                return ProductGridItem(
                                  title: product.name,
                                  price: product.priceLabel,
                                  imageUrl: product.thumbnail,
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
