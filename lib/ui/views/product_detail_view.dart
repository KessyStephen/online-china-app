import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/helpers/Utils.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/product_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/details_header.dart';
import 'package:online_china_app/ui/widgets/product_attribute.dart';
import 'package:provider/provider.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../base_widget.dart';

class ProductDetailView extends StatefulWidget {
  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    final String productId = params != null ? params['productId'] : "";

    var attributeWidgets = List<Widget>();

    Product product;

    return BaseView<ProductModel>(
      model: ProductModel(productService: Provider.of(context)),
      onModelReady: (model) async {
        product = await model.getProduct(productId: productId);

        if (product != null && product.attributes != null) {
          attributeWidgets.clear();
          for (var attr in product.attributes) {
            attributeWidgets.add(ProductAttribute(
              leftText: attr.name,
              rightText: attr.valueString,
            ));
          }
        }
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          //title: Text("Product Details"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                if (product != null && product.id != null) {
                  model.addToFavorites(
                      productId: product.id, hideLoading: true);
                }
              },
            ),
            BadgeIcon(
              count: model.cartItemCount.toString(),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, "/", (Route<dynamic> route) => false,
                  arguments: {"switchToIndex": CART_INDEX}),
            ),
          ],
        ),
        body: SafeArea(
          child: model.state == ViewState.Busy
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : product == null
                  ? Container()
                  : Column(
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
                                          viewportFraction: 1.0,
                                          enableInfiniteScroll: false,
                                          autoPlay: false),
                                      itemCount: product.images != null
                                          ? product.images.length
                                          : 0,
                                      itemBuilder: (BuildContext context,
                                          int itemIndex) {
                                        var imageItem =
                                            product.images[itemIndex];
                                        return CachedNetworkImage(
                                          imageUrl: imageItem.src != null
                                              ? imageItem.src
                                              : "",
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            PLACEHOLDER_IMAGE,
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      },
                                    ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10.0, top: 6),
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (product.minOrderQuantity > 0)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        "Min Order: ${product.minOrderQuantity} pc",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  if (product.canRequestSample)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: BigButton(
                                        titleColor: Colors.black,
                                        color: Color.fromRGBO(255, 222, 0, 1.0),
                                        buttonTitle: "REQUEST SAMPLE",
                                        functionality: () async {
                                          await model.clearCartData();
                                          await model.addToCart(product);
                                          model.setSampleRequestOrder(true);

                                          Map<String, dynamic> params = {
                                            'items': model.cartProducts,
                                            'total': product.samplePrice,
                                          };

                                          Navigator.pushNamed(
                                              context, '/confirm_order',
                                              arguments: params);

                                          // Navigator.pushNamedAndRemoveUntil(
                                          //     context,
                                          //     "/",
                                          //     (Route<dynamic> route) => false,
                                          //     arguments: {
                                          //       "switchToIndex": CART_INDEX
                                          //     });
                                        },
                                      ),
                                    ),
                                  if (attributeWidgets.length > 0)
                                    SizedBox(
                                      height: 10,
                                    ),
                                  if (attributeWidgets.length > 0)
                                    DetailsHeader(
                                      title: "About",
                                      rightText: "",
                                    ),

                                  ...attributeWidgets,

                                  SizedBox(
                                    height: 10,
                                  ),
                                  DetailsHeader(
                                    title: "Description",
                                    rightText: "See all >",
                                    onPressed: () => Navigator.pushNamed(
                                        context, "/product_description_full",
                                        arguments: {
                                          "title": product.name,
                                          "body": product.description
                                        }),
                                  ),
                                  // if (product.description != null)
                                  //   Container(
                                  //     height: 200,
                                  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  //     child: WebView(
                                  //       initialUrl: '',
                                  //       onWebViewCreated:
                                  //           (WebViewController webViewController) {
                                  //         _controller = webViewController;
                                  //         _loadHtmlFromAssets(
                                  //             product.description, _controller);
                                  //       },
                                  //     ),
                                  //   ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      product.description != null
                                          ? Utils.removeHtmlTags(
                                              product.description)
                                          : "",
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                                functionality: () async {
                                  await model.clearCartData();
                                  await model.addToCart(product);
                                  // Navigator.pushReplacementNamed(context, "/",
                                  //     arguments: {"switchToIndex": CART_INDEX});

                                  Navigator.pushNamedAndRemoveUntil(context,
                                      "/", (Route<dynamic> route) => false,
                                      arguments: {"switchToIndex": CART_INDEX});
                                },
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

  _loadHtmlFromAssets(htmlText, controller) async {
    controller.loadUrl(Uri.dataFromString(htmlText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}

class BadgeIcon extends StatelessWidget {
  final String count;
  final Function onPressed;
  const BadgeIcon({Key key, this.count, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: 18, left: 8),
        child: Stack(
          children: <Widget>[
            Icon(Icons.shopping_cart),
            Positioned(
              right: 0,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  this.count != null ? this.count : "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
