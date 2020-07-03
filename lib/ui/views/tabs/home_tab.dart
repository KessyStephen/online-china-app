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
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              snap: false,
              floating: false,
              backgroundColor: Colors.transparent,
              title: Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                height: 50,
                child: Image.asset(
                  "assets/images/logo_black.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              snap: true,
              floating: true,
              pinned: true,
              backgroundColor: const Color.fromRGBO(238, 52, 34, 1.0),
              title: Container(
                // height: 100,
                color: const Color.fromRGBO(238, 52, 34, 1.0),
                //padding: EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(
                          width: 16,
                        ),
                        InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, "/account"),
                            child: Icon(
                              CupertinoIcons.profile_circled,
                              color: Colors.white,
                              size: 35,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        right: 18, left: 18, bottom: 10, top: 18),
                    height: 170,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Best Selling Products",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                  if (model.bestSellingProducts.length > 0)
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 150.0,
                        maxHeight: 210.0,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Text("New Arrivals",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16)),
                    ),
                  if (model.newArrivalProducts.length > 0)
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 150.0,
                        maxHeight: 210.0,
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
              )
            ]))
          ],
        ),
      ),
    );
  }
}
