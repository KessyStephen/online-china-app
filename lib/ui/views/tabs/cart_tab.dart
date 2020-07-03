import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/user.dart';
import 'package:online_china_app/core/viewmodels/views/cart_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/views/base_view.dart';
import 'package:online_china_app/ui/widgets/auth_modal.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/empty_list.dart';
import 'package:online_china_app/ui/widgets/product_list_item.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CartTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Provider.of<User>(context).isLoggedIn;
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
                    : model.products.length == 0
                        ? EmptyListWidget(
                            message: "Cart is empty",
                          )
                        : ListView.builder(
                            itemCount: model.products.length,
                            shrinkWrap: false,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            itemBuilder: (BuildContext context, int index) {
                              var product = model.products[index];
                              return ProductListItem(
                                title: product.name,
                                price: product.priceLabel,
                                imageUrl: product.thumbnail,
                                quantity: product.quantity,
                                hideQuantityInput: false,
                                addItem: () => model.addToCart(product),
                                removeItem: () => model.removeFromCart(product),
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
                          model.total.toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  BigButton(
                    color: model.total > 0 ? primaryColor : Colors.grey,
                    buttonTitle: "CHECKOUT",
                    functionality: () {
                      // bool isLoggedIn =Provider.of<User>(context).isLoggedIn;
                      if (model.total > 0 &&
                          isLoggedIn) {
                        Map<String, dynamic> params = {
                          'items': model.products,
                          'total': model.total,
                        };

                        Navigator.pushNamed(context, '/confirm_order',
                            arguments: params);
                      }
                      if (model.total > 0 && !isLoggedIn) {
                        Get.bottomSheet(AuthModalWidget(
                          message: "Orders",
                          subText: "Please check your orders",
                        ));
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
