import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/viewmodels/views/home_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/banner_row.dart';
import 'package:online_china_app/ui/widgets/category_row.dart';
import 'package:online_china_app/ui/widgets/product_grid_item.dart';
import 'package:online_china_app/ui/widgets/search_bar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../base_widget.dart';

class HomeTabView extends StatefulWidget {
  @override
  _HomeTabViewState createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      model: HomeModel(productService: Provider.of(context)),
      onModelReady: (model) async {
        await model.getExchangeRate();

        await model.getCompanySettings();

        if (model.bestSellingProducts == null ||
            model.bestSellingProducts.length == 0) {
          model.getBestSellingProducts();
        }

        if (model.newArrivalProducts == null ||
            model.newArrivalProducts.length == 0) {
          model.getNewArrivalProducts();
        }

        if (model.favorites == null || model.favorites.length == 0) {
          model.getFavorites();
        }
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: () async {
            await model.getNewArrivalProducts();
            await model.getBestSellingProducts();

            _refreshController.refreshCompleted();
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                snap: false,
                floating: false,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  centerTitle: true,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: 45,
                          padding: EdgeInsets.only(right: 5),
                          child: Image.asset(
                            "assets/images/logo.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          "Shamwaa",
                          style: TextStyle(
                              fontFamily: "Century Gothic",
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  // title: Container(
                  //   margin: EdgeInsets.symmetric(vertical: 6),
                  //   height: 50,
                  //   child: Image.asset(
                  //     "assets/images/logo_black.png",
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
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
                    BannerRow(),
                    CategoryRow(
                      title: "Trending Categories",
                    ),
                    if (model.bestSellingProducts.length > 0 ||
                        model.state == ViewState.Busy)
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: model.state == ViewState.Busy
                            ? Shimmer.fromColors(
                                child: Text(
                                  "Best Selling Products",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                baseColor: Colors.grey[400],
                                highlightColor: Colors.white)
                            : Text(
                                "Best Selling Products",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                      ),
                    // if (model.bestSellingProducts.length > 0 || model.state == ViewState.Busy)
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 150.0,
                        maxHeight: 220.0,
                      ),
                      child: ViewState.Busy == model.state
                          ? Shimmer.fromColors(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 200,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(4, (index) {
                                        return Container(
                                          width: 200,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 5.0,
                                                ),
                                              ],
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: SizedBox(
                                            height: 100,
                                            width: 150,
                                          ),
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              ),
                              baseColor: Colors.grey[400],
                              highlightColor: Colors.white)
                          : ListView.builder(
                              itemCount: model.bestSellingProducts.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                var product = model.bestSellingProducts[index];
                                return ProductGridItem(
                                  title: product.name,
                                  price: product.priceLabel,
                                  minOrderQuantity: product.minOrderLabel,
                                  imageUrl: product.thumbnail,
                                  onPressed: () => Navigator.pushNamed(
                                      context, "/product_detail",
                                      arguments: {"productId": product.id}),
                                );
                              }),
                    ),
                    if (model.bestSellingProducts.length > 0 ||
                        model.state == ViewState.Busy)
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: model.state == ViewState.Busy
                            ? Shimmer.fromColors(
                                child: Text(
                                  "New Arrivals",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                baseColor: Colors.grey[400],
                                highlightColor: Colors.white)
                            : Text(
                                "New Arrivals",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                      ),
                    if (model.bestSellingProducts.length > 0 ||
                        model.state == ViewState.Busy)
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 150.0,
                          maxHeight: 220.0,
                        ),
                        child: ViewState.Busy == model.state
                            ? Shimmer.fromColors(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 200,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: List.generate(4, (index) {
                                          return Container(
                                            width: 200,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 5.0,
                                                  ),
                                                ],
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0))),
                                            child: SizedBox(
                                              height: 100,
                                              width: 150,
                                            ),
                                          );
                                        }),
                                      ),
                                    )
                                  ],
                                ),
                                baseColor: Colors.grey[400],
                                highlightColor: Colors.white)
                            : ListView.builder(
                                itemCount: model.newArrivalProducts.length,
                                shrinkWrap: false,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  var product = model.newArrivalProducts[index];
                                  return ProductGridItem(
                                    title: product.name,
                                    price: product.priceLabel,
                                    minOrderQuantity: product.minOrderLabel,
                                    imageUrl: product.thumbnail,
                                    onPressed: () => Navigator.pushNamed(
                                        context, "/product_detail",
                                        arguments: {"productId": product.id}),
                                  );
                                }),
                      )
                  ],
                )
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
