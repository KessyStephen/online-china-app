import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/models/banner_item.dart';
import 'package:online_china_app/core/viewmodels/views/banner_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class BannerRow extends StatefulWidget {
  const BannerRow({
    Key key,
  }) : super(key: key);

  @override
  _BannerRowState createState() => _BannerRowState();
}

class _BannerRowState extends State<BannerRow> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return BaseView<BannerModel>(
      model: BannerModel(bannerService: Provider.of(context)),
      onModelReady: (model) {
        if (model.banners == null || model.banners.length == 0) {
          model.getBanners();
        }
      },
      builder: (context, model, child) => (model.banners == null ||
              model.banners.length == 0)
          ? Container(
              height: 20,
            )
          : Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                      right: 18, left: 18, bottom: 10, top: 18),
                  height: 170,
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                        height: 200.0,
                        initialPage: 0,
                        scrollDirection: Axis.horizontal,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        // autoPlayInterval: Duration(seconds: 3),
                        // autoPlayAnimationDuration: Duration(milliseconds: 800),
                        // autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    itemCount: model.banners != null ? model.banners.length : 0,
                    itemBuilder: (BuildContext context, int itemIndex) {
                      BannerItem bannerItem = model.banners[itemIndex];
                      return InkWell(
                        onTap: () {
                          //check if it's product banner
                          if (bannerItem.productId != null &&
                              bannerItem.productId.isNotEmpty) {
                            Navigator.pushNamed(context, "/product_detail",
                                arguments: {"productId": bannerItem.productId});
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          // color: Colors.white,
                          // decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius:
                          //         const BorderRadius.all(Radius.circular(20))),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: bannerItem.image != null
                                  ? bannerItem.image
                                  : "",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(
                                PLACEHOLDER_IMAGE,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                    bottom: 12,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: model.banners.map((url) {
                          int index = model.banners.indexOf(url);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey, width: 1),
                              color: _current == index
                                  ? primaryColor
                                  : Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    )),
              ],
            ),
    );
  }
}
