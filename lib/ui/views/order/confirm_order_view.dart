import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/cart_model.dart';
import 'package:online_china_app/core/viewmodels/views/order_model.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/product_list_item.dart';
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
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("Order Details")),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: products != null ? products.length : 0,
                  shrinkWrap: false,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemBuilder: (BuildContext context, int index) {
                    var product = products[index];
                    return ProductListItem(
                      title: product.name,
                      price: product.priceLabel,
                      imageUrl: "https://onlinechina.co/logo.png",
                      quantity: product.quantity,
                      hideQuantityInput: true,
                      // addItem: () => model.addToCart(product),
                      // removeItem: () => model.removeFromCart(product),
                    );

                    // return ProductListItem(
                    //   title:
                    //       "Go-Pro Full set with 23 Macro lenses 24MP, 48MP with Tripod Stand",
                    //   price: "TZS 750,000",
                    //   imageUrl: "https://onlinechina.co/logo.png",
                    //   hideQuantityInput: false,

                    // );
                  },
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
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
                          total.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  BigButton(
                    buttonTitle: "CONFIRM",
                    functionality: () async {
                      bool success =
                          await model.createOrder(products: products);
                      if (success) {
                        // model.clearCart();
                        // Navigator.pushNamed(context, '/');
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
