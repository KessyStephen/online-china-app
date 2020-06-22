import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:online_china_app/core/viewmodels/views/order_model.dart';
import 'package:online_china_app/ui/views/base_view.dart';
import 'package:online_china_app/ui/widgets/order_list_item.dart';
import 'package:provider/provider.dart';

class OrdersTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<OrderModel>(
        model: OrderModel(orderService: Provider.of(context)),
        onModelReady: (model) => model.getOrders(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(title: Text("Orders")),
              body: SafeArea(
                child: ListView.builder(
                  itemCount: 6,
                  shrinkWrap: false,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return OrderListItem(
                      orderID: "#123123",
                      orderDate: "27 JAN 2020",
                      paymentStatus: "UNPAID",
                      itemCount: "X 4 Items",
                      price: "TZS 720,000",
                    );
                  },
                ),
              ),
            ));
  }
}
