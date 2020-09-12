import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/helpers/Utils.dart';
import 'package:online_china_app/core/models/shipping_details.dart';
import 'package:online_china_app/core/viewmodels/views/order_model.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/shipping_method_list_item.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../base_widget.dart';

class OrderShippingMethodView extends StatefulWidget {
  @override
  _OrderShippingMethodViewState createState() =>
      _OrderShippingMethodViewState();
}

class _OrderShippingMethodViewState extends State<OrderShippingMethodView> {
  String selectedShippingMethod = SHIPPING_METHOD_SEA_VALUE;

  @override
  Widget build(BuildContext context) {
    ShippingDetails shippingDetails = Provider.of<ShippingDetails>(context);
    return BaseView<OrderModel>(
      model: OrderModel(orderService: Provider.of(context)),
      onModelReady: (model) {
        selectedShippingMethod = model.shippingMethod;
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: Text("Shipping Details")),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(210, 52, 5, 0.02),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 6),
                                alignment: Alignment.center,
                                child: Image(
                                  height: 80.0,
                                  image: AssetImage(
                                      'assets/images/packing_icon.png'),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                        "Quantity : ${model.cartItemCountWithVariations}"),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(bottom: 6),
                                  //   child: Text(
                                  //       "Size : 20cm * 20cm * 20cm / pair"),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                        "Total Weight : ${shippingDetails.totalWeight.toStringAsFixed(2)} kg"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                        "Total CBM : ${shippingDetails.totalCBM.toStringAsFixed(6)}"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Ships To "),
                              Text(
                                model.destCountry ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(Icons.location_on),
                              Text(model.destCountry ?? ""),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Shipping Methods"),
                        ),
                        ShippingMethodListItem(
                          shippingMethod: SHIPPING_METHOD_AIR_VALUE,
                          estimatedPrice:
                              Utils.formatNumber(model.airShippingCost),
                          estimatedDeliveryTime:
                              model.companySettings?.estimatedDeliveryTimeByAir,
                          checked: selectedShippingMethod ==
                              SHIPPING_METHOD_AIR_VALUE,
                          onPressed: () {
                            setState(() {
                              selectedShippingMethod =
                                  SHIPPING_METHOD_AIR_VALUE;
                            });
                          },
                        ),
                        ShippingMethodListItem(
                          shippingMethod: SHIPPING_METHOD_SEA_VALUE,
                          estimatedPrice:
                              Utils.formatNumber(model.seaShippingCost),
                          estimatedDeliveryTime: model
                              .companySettings?.estimatedDeliveryTimeByShip,
                          checked: selectedShippingMethod ==
                              SHIPPING_METHOD_SEA_VALUE,
                          onPressed: () {
                            setState(() {
                              selectedShippingMethod =
                                  SHIPPING_METHOD_SEA_VALUE;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  BigButton(
                    buttonTitle: "Apply",
                    functionality: () async {
                      model.updateShippingDetails(
                          shippingMethod: selectedShippingMethod);
                      Navigator.pop(context);
                    },
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
