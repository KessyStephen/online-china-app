import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';

class ProductListItem extends StatelessWidget {
  final String title;
  final String price;
  final int quantity;
  final String imageUrl;
  final bool hideQuantityInput;
  final Function addItem;
  final Function removeItem;
  final Function onPressed;

  const ProductListItem(
      {Key key,
      this.title,
      this.price,
      this.quantity,
      this.imageUrl,
      this.hideQuantityInput,
      this.addItem,
      this.removeItem,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(children: <Widget>[
          Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black54, width: 1.0)),
              child: CachedNetworkImage(
                imageUrl: this.imageUrl != null ? this.imageUrl : "",
                fit: BoxFit.contain,
                placeholder: (context, url) => Image.asset(
                  PLACEHOLDER_IMAGE,
                  fit: BoxFit.contain,
                ),
              )),
          Expanded(
            flex: 1,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(this.title != null ? this.title : ""),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          this.price != null ? this.price : "",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        if (this.hideQuantityInput != true)
                          QuantityInput(
                              addItem: this.addItem,
                              removeItem: this.removeItem,
                              quantity:
                                  this.quantity != null ? this.quantity : 0)
                      ])
                ]),
          )
        ]),
      ),
    );
  }
}

class QuantityInput extends StatelessWidget {
  final Function addItem;
  final Function removeItem;
  final int quantity;

  QuantityInput({this.addItem, this.removeItem, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: this.removeItem,
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 8),
              child: const Text(
                "-",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Container(
            width: 1,
            margin: const EdgeInsets.only(right: 8),
            color: Colors.grey,
            child: const Text(""),
          ),
          Text(this.quantity.toString()),
          Container(
            width: 1,
            margin: const EdgeInsets.only(left: 8),
            color: Colors.grey,
            child: const Text(""),
          ),
          InkWell(
            onTap: this.addItem,
            child: Container(
              padding: const EdgeInsets.only(left: 8, right: 10),
              child: const Text(
                "+",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
