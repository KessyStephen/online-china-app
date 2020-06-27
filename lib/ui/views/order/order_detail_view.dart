import 'package:flutter/material.dart';
import 'package:online_china_app/core/helpers/utils.dart';
import 'package:online_china_app/core/models/order.dart';

class OrderDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    Order order = params != null ? params['order'] : null;

    return Scaffold(
      appBar: AppBar(title: Text("Order Details")),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          OrderProperty(
              keyText: "Date: ", valueText: Utils.displayDate(order.createdAt)),
          OrderProperty(keyText: "Status: ", valueText: order.status),
        ],
      )),
    );
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
