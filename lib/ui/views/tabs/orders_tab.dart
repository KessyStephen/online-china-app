import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/helpers/utils.dart';
import 'package:online_china_app/core/viewmodels/views/order_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/views/base_view.dart';
import 'package:online_china_app/ui/widgets/empty_list.dart';
import 'package:online_china_app/ui/widgets/order_list_item.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class OrdersTabView extends StatefulWidget {
  @override
  _OrdersTabViewState createState() => _OrdersTabViewState();
}

class _OrdersTabViewState extends State<OrdersTabView> {
  int page = 2;
  bool showLoading = true;

  @override
  Widget build(BuildContext context) {
    return BaseView<OrderModel>(
      model: OrderModel(orderService: Provider.of(context)),
      onModelReady: (model) {
        if (model.orders == null || model.orders.length == 0) {
          model.getOrders(perPage: PER_PAGE_COUNT);
        }
      },
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
                  ? EmptyListWidget(
                      message: "No Orders",
                    )
                  : InfiniteListView.separated(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemBuilder: (context, index) {
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
                                arguments: {"orderId": order.id});
                          },
                        );
                      },
                      itemCount: model.orders != null
                          ? model.orders.length
                          : 0, // Current itemCount you have
                      hasNext: model.orders.length >= PER_PAGE_COUNT
                          ? this.showLoading
                          : false, // if we have fewer than requested, there is no next
                      nextData: () => this.loadNextData(
                          model), // callback called when end to the list is reach and hasNext is true
                      separatorBuilder: (context, index) => Divider(height: 1),
                    ),
        ),
      ),
    );
  }

  void loadNextData(OrderModel model) async {
    bool flag = await model.getOrders(
        hideLoading: true, page: this.page, perPage: PER_PAGE_COUNT);
    if (flag) {
      setState(() {
        this.page++;
      });
    } else {
      setState(() {
        this.showLoading = false;
      });
    }
  }
}
