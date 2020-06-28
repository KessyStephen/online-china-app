import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/cart_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/details_header.dart';
import 'package:online_china_app/ui/widgets/product_attribute.dart';
import 'package:provider/provider.dart';
import 'package:online_china_app/core/enums/constants.dart';

import '../base_widget.dart';

class ProductDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;

    return BaseView<CartModel>(
      model: CartModel(cartService: Provider.of(context)),
      onModelReady: (model) => {},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text(product.name)),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // SizedBox(
                        //   height: 200,
                        // ),
                        if (product.images != null)
                          CarouselSlider.builder(
                            options: CarouselOptions(
                                height: 200.0,
                                initialPage: 0,
                                scrollDirection: Axis.horizontal,
                                viewportFraction: 1.0),
                            itemCount: product.images != null
                                ? product.images.length
                                : 0,
                            itemBuilder: (BuildContext context, int itemIndex) {
                              var imageItem = product.images[itemIndex];
                              return CachedNetworkImage(
                                imageUrl:
                                    imageItem.src != null ? imageItem.src : "",
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Image.asset(
                                  PLACEHOLDER_IMAGE,
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            product.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            product.priceLabel,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (product.minOrderQuantity > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              "Min Order: ${product.minOrderQuantity} pc",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        DetailsHeader(
                          title: "About",
                          rightText: "See all >",
                        ),
                        ProductAttribute(
                          leftText: "Condition",
                          rightText: "New",
                        ),
                        ProductAttribute(
                          leftText: "Brand",
                          rightText: "Apple",
                        ),
                        ProductAttribute(
                          leftText: "Screen Size",
                          rightText: "5.5",
                        ),
                        ProductAttribute(
                          leftText: "Model",
                          rightText: "iPhone 8 Plus",
                        ),
                        DetailsHeader(
                          title: "Description",
                          rightText: "See all >",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(product.description != null
                              ? product.description
                              : ""),
                        ),
                        // InkWell(
                        //   child: Text("ADD"),
                        //   onTap: () => model.addToCart(product),
                        // ),
                        // InkWell(
                        //   child: Text("REMOVE"),
                        //   onTap: () => model.removeFromCart(product),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: BigButton(
                      color: primaryColor,
                      buttonTitle: "ADD TO ITEMS",
                      functionality: () => model.addToCart(product),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: BigButton(
                      color: Color.fromRGBO(152, 2, 32, 1.0),
                      buttonTitle: "BUY NOW",
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
