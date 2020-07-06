import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/order.dart';
import 'package:online_china_app/core/viewmodels/views/order_model.dart';
import 'package:online_china_app/ui/views/base_view.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/orderitem_list_item.dart';
import 'package:provider/provider.dart';

class OrderDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    final String orderId = params != null ? params['orderId'] : "";

    Order order;
    return BaseView<OrderModel>(
        model: OrderModel(orderService: Provider.of(context)),
        onModelReady: (model) async {
          order = await model.getOrder(orderId: orderId);
        },
        builder: (context, model, child) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(title: Text("Order Details")),
              body: SafeArea(
                child: model.state == ViewState.Busy
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : order == null
                        ? Container()
                        : Column(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: ListView.builder(
                                  itemCount: order.products != null
                                      ? order.products.length
                                      : 0,
                                  shrinkWrap: false,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var product = order.products[index];
                                    return OrderItemListItem(
                                      title: product.name,
                                      price: product.priceLabel,
                                      imageUrl: product.thumbnail,
                                      quantity: product.quantity,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Total Amount",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          order.priceLabel,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  BigButton(
                                    buttonTitle: "GET INVOICE",
                                    functionality: () async {},
                                  )
                                ],
                              )
                            ],
                          ),
              ),
            ));
  }
}

class OrderProperty extends StatelessWidget {
  final String keyText;
  final String valueText;
  const OrderProperty({Key key, this.keyText, this.valueText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Text(this.keyText != null ? this.keyText : ""),
          Text(this.valueText != null ? this.valueText : ""),
        ],
      ),
    );
  }
}
