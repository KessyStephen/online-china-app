import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/helpers/utils.dart';
import 'package:online_china_app/core/viewmodels/views/order_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/views/base_view.dart';
import 'package:online_china_app/ui/widgets/empty_list.dart';
import 'package:online_china_app/ui/widgets/order_list_item.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class OrdersTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<OrderModel>(
      model: OrderModel(orderService: Provider.of(context)),
      onModelReady: (model) => model.getOrders(hideLoading: true),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("Orders"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: model.state == ViewState.Busy
              ? ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, left: 16, right: 16),
                      color: Colors.grey,
                      height: 100,
                    ),
                  ),
                )
              : model.orders.length == 0
                  ? EmptyListWidget(message: "No Orders",)
                  : ListView.builder(
                      itemCount: model.orders.length,
                      shrinkWrap: false,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemBuilder: (BuildContext context, int index) {
                        var order = model.orders[index];
                        return OrderListItem(
                          orderID: order.referenceId.toString(),
                          orderDate: Utils.displayDate(order.createdAt),
                          paymentStatus: order.status,
                          itemCount: order.itemCount > 0
                              ? "X ${order.itemCount} Items"
                              : "",
                          price: order.priceLabel,
                          onPressed: () {
                            Navigator.pushNamed(context, "/order_detail",
                                arguments: {"order": order});
                          },
                        );

                        //        return OrderListItem(
                        //   orderID: "#123123",
                        //   orderDate: "27 JAN 2020",
                        //   paymentStatus: "UNPAID",
                        //   itemCount: "X 4 Items",
                        //   price: "TZS 720,000",
                        // );
                      },
                    ),
        ),
      ),
    );
  }
}
