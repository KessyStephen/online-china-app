import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/cart_model.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class ProductDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;

    return BaseView<CartModel>(
      model: CartModel(cartService: Provider.of(context)),
      onModelReady: (model) => {},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text(product.name)),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Text(product.priceLabel),
              InkWell(
                child: Text("ADD"),
                onTap: () => model.addToCart(product),
              ),
              InkWell(
                child: Text("REMOVE"),
                onTap: () => model.removeFromCart(product),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
