import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:online_china_app/core/viewmodels/views/cart_model.dart';
import 'package:online_china_app/ui/views/base_view.dart';
import 'package:online_china_app/ui/widgets/product_list_item.dart';
import 'package:provider/provider.dart';

class CartTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<CartModel>(
      model: CartModel(cartService: Provider.of(context)),
      onModelReady: (model) => {},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("My Items")),
        body: SafeArea(
          child: ListView.builder(
            itemCount: model.products.length,
            shrinkWrap: false,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemBuilder: (BuildContext context, int index) {
              var product = model.products[index];
              return ProductListItem(
                title: product.name,
                price: product.priceLabel,
                imageUrl: "https://onlinechina.co/logo.png",
                quantity: product.quantity,
                hideQuantityInput: false,
                addItem: () => model.addToCart(product),
                removeItem: () => model.removeFromCart(product),
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
      ),
    );
  }
}
