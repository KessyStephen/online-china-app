import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/helpers/utils.dart';
import 'package:online_china_app/core/models/shipping_details.dart';
import 'package:online_china_app/core/models/user.dart';
import 'package:online_china_app/core/viewmodels/views/cart_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/views/base_view.dart';
import 'package:online_china_app/ui/widgets/auth_modal.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/empty_list.dart';
import 'package:online_china_app/ui/widgets/product_list_item.dart';
import 'package:online_china_app/ui/widgets/product_options_modal.dart';
import 'package:online_china_app/ui/widgets/shipping_summary.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CartTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Provider.of<User>(context).isLoggedIn;
    ShippingDetails shippingDetails = Provider.of<ShippingDetails>(context);

    return BaseView<CartModel>(
      model: CartModel(cartService: Provider.of(context)),
      onModelReady: (model) => {},
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("My Items"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: model.state == ViewState.Busy
                    ? ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) => Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.white,
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: 10, left: 16, right: 16),
                            color: Colors.grey,
                            height: 100,
                          ),
                        ),
                      )
                    : model.cartProducts.length == 0
                        ? EmptyListWidget(
                            message: "Empty list",
                          )
                        : ListView.builder(
                            itemCount: model.cartProducts.length,
                            shrinkWrap: false,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            itemBuilder: (BuildContext context, int index) {
                              var product = model.cartProducts[index];
                              return ProductListItem(
                                type: product.type,
                                title: product.name,
                                price: model.isSampleRequest
                                    ? product.samplePriceLabel
                                    : product.priceLabel,
                                imageUrl: product.thumbnail,
                                quantity: product.type == PRODUCT_TYPE_VARIABLE
                                    ? product.variationsItemCount
                                    : product.quantity,
                                hideQuantityInput: false,
                                showDelete: true,
                                onDelete: () => model.removeFromCart(product),
                                minQuantity: 1,
                                onQuantityChanged: (value) {
                                  product.setQuantity(value);
                                  model.updateProductInCart(product);
                                  // model.setState(ViewState.Idle);
                                },
                                addItem: () {
                                  product.increaseQuantity(1);
                                  model.updateProductInCart(product);
                                  // model.setState(ViewState.Idle);
                                },
                                removeItem: () {
                                  product.increaseQuantity(-1);
                                  model.updateProductInCart(product);
                                  // model.setState(ViewState.Idle);
                                },
                                onEditQuantity: () {
                                  if (product.type == PRODUCT_TYPE_VARIABLE) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => ProductOptionsModal(
                                        action: ProductAction.Update,
                                        product: product,
                                        onAddToCart: () =>
                                            model.addToCart(product),
                                      ),
                                    );
                                    return;
                                  }
                                },
                              );
                            },
                          ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Total Amount",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                // Text(
                                //   "(Without Shipping)",
                                //   style: const TextStyle(fontSize: 11),
                                // ),
                              ],
                            ),
                            Text(
                              Utils.formatNumber(
                                  model.cartTotalWithServiceCharge),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (model?.companySettings?.serviceChargePercent !=
                            null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Service Charge (${model?.companySettings?.serviceChargePercent}%)",
                                  style: const TextStyle(fontSize: 11),
                                ),
                                Text(
                                  Utils.formatNumber(model.serviceChargeAmount),
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                  // ShippingSummary(
                  //   country: shippingDetails.destCountry,
                  //   shippingMethod: shippingDetails.shippingMethod,
                  //   estimatedPrice: shippingDetails.shippingMethod ==
                  //           SHIPPING_METHOD_AIR_VALUE
                  //       ? Utils.formatNumber(shippingDetails.airShippingCost)
                  //       : Utils.formatNumber(shippingDetails.seaShippingCost),
                  //   estimatedDeliveryTime: shippingDetails.shippingMethod ==
                  //           SHIPPING_METHOD_AIR_VALUE
                  //       ? model.companySettings?.estimatedDeliveryTimeByAir
                  //       : model.companySettings?.estimatedDeliveryTimeByShip,
                  //   onPressed: () {
                  //     navigator.pushNamed("/order_shipping_method");
                  //   },
                  // ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: BigButton(
                          color: primaryColor,
                          buttonTitle: "GO TO SHOP",
                          functionality: () {
                            Navigator.pushNamedAndRemoveUntil(context, "/home",
                                (Route<dynamic> route) => false,
                                arguments: {"switchToIndex": 0});
                          },
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: BigButton(
                            color: model.cartTotal > 0
                                ? Color.fromRGBO(152, 2, 32, 1.0)
                                : Colors.grey,
                            buttonTitle: "CHECKOUT",
                            functionality: () {
                              // bool isLoggedIn =Provider.of<User>(context).isLoggedIn;
                              if (model.cartTotal > 0 && isLoggedIn) {
                                Map<String, dynamic> params = {
                                  'items': model.cartProducts,
                                  'total': model.cartTotal,
                                  'totalWithServiceCharge':
                                      model.cartTotalWithServiceCharge,
                                  'serviceChargeAmount':
                                      model.serviceChargeAmount,
                                };

                                Navigator.pushNamed(context, '/order_address',
                                    arguments: params);
                              }
                              if (model.cartTotal > 0 && !isLoggedIn) {
                                Get.bottomSheet(AuthModalWidget(
                                  message: "Orders",
                                  subText: "Please check your orders",
                                ));
                              }
                            },
                          )),
                    ],
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
