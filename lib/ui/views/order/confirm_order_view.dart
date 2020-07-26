import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/cart_model.dart';
import 'package:online_china_app/core/viewmodels/views/order_model.dart';
import 'package:online_china_app/ui/widgets/auth_modal.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/order_success_modal.dart';
import 'package:online_china_app/ui/widgets/product_list_item.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../base_widget.dart';

class ConfirmOrderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    List<Product> products = params != null ? params['items'] : null;
    double total = params != null ? params['total'] : null;

    return BaseView<OrderModel>(
      model: OrderModel(orderService: Provider.of(context)),
      onModelReady: (model) => {},
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          if (model.isSampleRequest == true) {
            await model.clearCartData();
          }
          return Future<bool>.value(true);
        },
        child: Scaffold(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Total Amount",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                total.toStringAsFixed(2),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        BigButton(
                          buttonTitle: "CONFIRM",
                          functionality: () async {
                            List<String> orderIds =
                                await model.createOrder(products: products);
                            if (orderIds != null && orderIds.length > 0) {
                              await model.clearCartData();

                              Get.bottomSheet(OrderSuccessModal(
                                onGetInvoice: () async {
                                  String orderId = orderIds[0];

                                  await Navigator.pop(context);
                                  // await Navigator.popAndPushNamed(context, "/",
                                  //     arguments: {"switchToIndex": ORDERS_INDEX});

                                  Navigator.pushReplacementNamed(
                                      context, "/order_detail",
                                      arguments: {"orderId": orderId});

                                  // Get.back();
                                  // String response = await model.getInvoiceHTML(
                                  //     orderId: orderId);
                                  // var invoicePDFData = await model
                                  //     .generateInvoicePDF(htmlContent: response);
                                  // await sharePDF(invoicePDFData, orderId);
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
      ),
    );
  }

  Future<void> sharePDF(var htmlContent, String filename) async {
    filename = filename + ".pdf";
    await Printing.sharePdf(bytes: htmlContent, filename: filename);
  }
}
