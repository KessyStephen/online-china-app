import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/helpers/utils.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/models/shipping_details.dart';
import 'package:online_china_app/core/viewmodels/views/cart_model.dart';
import 'package:online_china_app/core/viewmodels/views/order_model.dart';
import 'package:online_china_app/ui/widgets/auth_modal.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/order_success_modal.dart';
import 'package:online_china_app/ui/widgets/product_list_item.dart';
import 'package:online_china_app/ui/widgets/shipping_summary.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../base_widget.dart';

class ConfirmOrderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ShippingDetails shippingDetails = Provider.of<ShippingDetails>(context);
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    List<Product> products = params != null ? params['items'] : null;
    double total = params != null ? params['total'] : null;
    double totalWithServiceCharge =
        params != null ? params['totalWithServiceCharge'] : null;
    double serviceChargeAmount =
        params != null ? params['serviceChargeAmount'] : null;

    String destCountry = params != null ? params['destCountry'] : null;
    String destCity = params != null ? params['destCity'] : null;
    String destRegion = params != null ? params['destRegion'] : null;
    String destStreet = params != null ? params['destStreet'] : null;

    return BaseView<OrderModel>(
      model: OrderModel(orderService: Provider.of(context)),
      onModelReady: (model) => {},
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: Text("Order Details")),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              if (model.state == ViewState.Busy)
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: products != null ? products.length : 0,
                      shrinkWrap: false,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemBuilder: (BuildContext context, int index) {
                        var product = products[index];
                        return ProductListItem(
                          type: product.type,
                          title: product.name,
                          price: model.isSampleRequest
                              ? product.samplePriceLabel
                              : product.priceLabel,
                          imageUrl: product.thumbnail,
                          quantity: product.quantity,
                          hideQuantityInput: true,
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
                                    Text(
                                      "(Without Shipping)",
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                                Text(
                                  Utils.formatNumber(totalWithServiceCharge),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            if (model?.companySettings?.serviceChargePercent !=
                                null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Service Charge (${model?.companySettings?.serviceChargePercent}%)",
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    Text(
                                      Utils.formatNumber(serviceChargeAmount),
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                      ShippingSummary(
                        country: shippingDetails.destCountry,
                        shippingMethod: shippingDetails.shippingMethod,
                        estimatedPrice: shippingDetails.shippingMethod ==
                                SHIPPING_METHOD_AIR_VALUE
                            ? Utils.formatNumber(
                                shippingDetails.airShippingCost)
                            : Utils.formatNumber(
                                shippingDetails.seaShippingCost),
                        estimatedDeliveryTime: shippingDetails.shippingMethod ==
                                SHIPPING_METHOD_AIR_VALUE
                            ? model.companySettings?.estimatedDeliveryTimeByAir
                            : model
                                .companySettings?.estimatedDeliveryTimeByShip,
                        onPressed: () {
                          navigator.pushNamed("/order_shipping_method");
                        },
                      ),
                      BigButton(
                        buttonTitle: "CONFIRM",
                        functionality: () async {
                          List<String> orderIds = await model.createOrder(
                              products: products,
                              shippingMethod: model.shippingMethod ==
                                      SHIPPING_METHOD_AIR_VALUE
                                  ? SHIPPING_METHOD_AIR_KEY
                                  : SHIPPING_METHOD_SEA_KEY,
                              destCountry: model.destCountry,
                              destCity: destCity,
                              destRegion: destRegion,
                              destStreet: destStreet);
                          if (orderIds != null && orderIds.length > 0) {
                            await model.clearCartData();

                            Get.bottomSheet(OrderSuccessModal(
                              onGetInvoice: () async {
                                String orderId = orderIds[0];

                                // await Navigator.pop(context);
                                int count = 0;
                                Navigator.popUntil(context, (route) {
                                  return count++ == 2;
                                });

                                Navigator.pushReplacementNamed(
                                    context, "/order_detail",
                                    arguments: {"orderId": orderId});
                              },
                            ));
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sharePDF(var htmlContent, String filename) async {
    filename = filename + ".pdf";
    await Printing.sharePdf(bytes: htmlContent, filename: filename);
  }
}
