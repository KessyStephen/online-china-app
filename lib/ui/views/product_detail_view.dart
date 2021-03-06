import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/helpers/utils.dart';
import 'package:online_china_app/core/models/favorite.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/product_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/details_header.dart';
import 'package:online_china_app/ui/widgets/product_attribute.dart';
import 'package:online_china_app/ui/widgets/product_options_modal.dart';
import 'package:online_china_app/ui/widgets/quantity_input.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:online_china_app/core/enums/constants.dart';

import '../base_widget.dart';

class ProductDetailView extends StatefulWidget {
  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    final String productId = params != null ? params['productId'] : "";

    var attributeWidgets = List<Widget>();
    var specificationWidgets = List<Widget>();

    Product product;
    Favorite favorite;

    return BaseView<ProductModel>(
      model: ProductModel(productService: Provider.of(context)),
      onModelReady: (model) async {
        product = await model.getProduct(productId: productId);
        favorite = await model.getFavoriteForProduct(productId: productId);

        //attributes
        if (product != null && product.attributes != null) {
          attributeWidgets.clear();
          for (var attr in product.attributes) {
            attributeWidgets.add(ProductAttribute(
              leftText: attr.name,
              rightText: attr.valueString,
            ));
          }
        }

        //specifications
        if (product != null && product.specifications != null) {
          specificationWidgets.clear();
          for (var spec in product.specifications) {
            specificationWidgets.add(ProductAttribute(
              leftText: spec.name,
              rightText: spec.value,
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
              icon: favorite != null
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              onPressed: () async {
                if (product != null && product.id != null) {
                  if (favorite != null) {
                    //remove
                    bool isRemoved = await model.deleteFromFavorites(
                        favoriteId: favorite.id, hideLoading: true);
                    if (isRemoved) {
                      favorite = null;
                    }
                  } else {
                    //add
                    var favoriteId = await model.addToFavorites(
                        productId: product.id, hideLoading: true);
                    if (favoriteId != null) {
                      favorite = Favorite(id: favoriteId, product: product);
                    }
                  }
                }
              },
            ),
            BadgeIcon(
              count: model.cartItemCount.toString(),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (Route<dynamic> route) => false,
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
                                        return InkWell(
                                          onTap: () {
                                            openInGallery(context,
                                                product.images, itemIndex);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            child: CachedNetworkImage(
                                              imageUrl: imageItem.src != null
                                                  ? imageItem.src
                                                  : "",
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                PLACEHOLDER_IMAGE,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          product.priceLabel,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if (product.variations == null ||
                                            product.variations.length == 0)
                                          QuantityInput(
                                              minQuantity: 1,
                                              onQuantityChanged: (value) {
                                                product.setQuantity(value);
                                                model.setState(ViewState.Idle);
                                              },
                                              addItem: () {
                                                product.increaseQuantity(1);
                                                model.setState(ViewState.Idle);
                                              },
                                              removeItem: () {
                                                product.increaseQuantity(-1);
                                                model.setState(ViewState.Idle);
                                              },
                                              quantity: product.quantity != null
                                                  ? product.quantity
                                                  : 0),
                                      ],
                                    ),
                                  ),
                                  if (product.minOrderQuantity > 0)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        "Min Order: ${product.minOrderLabel}",
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
                                          model.setSampleRequestOrder(true);
                                          await model.addToCart(product);

                                          double sampleServiceChargePercent =
                                              model.companySettings
                                                      .serviceChargePercent ??
                                                  0;
                                          double sampleServiceChargeAmount =
                                              (sampleServiceChargePercent *
                                                      product.samplePrice) /
                                                  100;

                                          Map<String, dynamic> params = {
                                            'items': model.cartProducts,
                                            'total': product.samplePrice,
                                            'totalWithServiceCharge':
                                                product.samplePrice +
                                                    sampleServiceChargeAmount,
                                            'serviceChargeAmount':
                                                sampleServiceChargeAmount,
                                          };

                                          Navigator.pushNamed(
                                              context, '/order_address',
                                              arguments: params);
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

                                  if (specificationWidgets.length > 0)
                                    SizedBox(
                                      height: 10,
                                    ),

                                  if (specificationWidgets.length > 0)
                                    DetailsHeader(
                                      title: "Specifications",
                                      rightText: "",
                                    ),

                                  ...specificationWidgets,

                                  SizedBox(
                                    height: 10,
                                  ),

                                  if (product.description != null &&
                                      product.description.isNotEmpty)
                                    DetailsHeader(
                                      title: "Description",
                                      rightText: "See all >",
                                      onPressed: () => Navigator.pushNamed(
                                          context, "/product_description_full",
                                          arguments: {
                                            "title": "Description",
                                            "body": product.description
                                          }),
                                    ),

                                  if (product.description != null &&
                                      product.description.isNotEmpty)
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
                                functionality: () {
                                  if (product.type == PRODUCT_TYPE_VARIABLE &&
                                      product.variations != null &&
                                      product.variations.length > 0) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => ProductOptionsModal(
                                        action: ProductAction.AddToItems,
                                        product: product,
                                        onAddToCart: () => this
                                            ._handleAddToCart(model, product),
                                      ),
                                    );
                                    // Get.bottomSheet(ProductOptionsModal());
                                    return;
                                  }

                                  //simple product
                                  this._handleAddToCart(model, product);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: BigButton(
                                color: Color.fromRGBO(152, 2, 32, 1.0),
                                buttonTitle: "BUY NOW",
                                functionality: () async {
                                  if (product.type == PRODUCT_TYPE_VARIABLE &&
                                      product.variations != null &&
                                      product.variations.length > 0) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => ProductOptionsModal(
                                        action: ProductAction.BuyNow,
                                        product: product,
                                        onBuyNow: () =>
                                            this._handleBuyNow(model, product),
                                      ),
                                    );
                                    return;
                                  }

                                  //simple product
                                  this._handleBuyNow(model, product);
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

  _handleAddToCart(model, product) async {
    await model.setBuyNowOrder(false);
    model.addToCart(product);
  }

  _handleBuyNow(model, product) async {
    await model.setBuyNowOrder(true);
    var success = await model.addToCart(product);

    //make sure product can be added successful before clearing the cart
    if (success) {
      await model.clearCartData();
      await model.setBuyNowOrder(true);
      await model.addToCart(product);

      Map<String, dynamic> params = {
        'items': model.cartProducts,
        'total': model.cartTotal,
        'totalWithServiceCharge': model.cartTotalWithServiceCharge,
        'serviceChargeAmount': model.serviceChargeAmount,
      };

      Navigator.pushNamed(context, '/order_address', arguments: params);
    }
  }

  void openInGallery(
      BuildContext context, List<ImageItem> galleryItems, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
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

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<ImageItem> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              padding: const EdgeInsets.all(18.0),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "${currentIndex + 1} / ${widget.galleryItems.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    decoration: null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final ImageItem item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: item.src != null && item.src.isNotEmpty
          ? CachedNetworkImageProvider(
              item.src,
            )
          : Image.asset(
              PLACEHOLDER_IMAGE,
              fit: BoxFit.contain,
            ),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}
