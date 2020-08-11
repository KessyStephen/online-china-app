import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/quantity_input.dart';

class ProductListItem extends StatelessWidget {
  final String type;
  final String title;
  final String price;
  final int quantity;
  final String imageUrl;
  final bool hideQuantityInput;
  final int minQuantity;
  final ValueChanged<int> onQuantityChanged;
  final bool showDelete;
  final Function addItem;
  final Function removeItem;
  final Function onPressed;
  final Function onEditQuantity;
  final Function onDelete;

  const ProductListItem(
      {Key key,
      this.type,
      this.title,
      this.price,
      this.quantity,
      this.imageUrl,
      this.hideQuantityInput,
      this.minQuantity,
      this.onQuantityChanged,
      this.showDelete,
      this.addItem,
      this.removeItem,
      this.onPressed,
      this.onEditQuantity,
      this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Color(0xffdfe4ea),
            blurRadius: 10.0, // has the effect of softening the shadow
            // spreadRadius: 8.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              10.0, // vertical, move down 10
            ),
          )
        ]),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(children: <Widget>[
          Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.only(right: 8),
              child: this.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: this.imageUrl != null ? this.imageUrl : "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        PLACEHOLDER_IMAGE,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      PLACEHOLDER_IMAGE,
                      fit: BoxFit.cover,
                    )),
          Expanded(
            flex: 1,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Text(this.title != null ? this.title : "")),
                      if (showDelete == true)
                        IconButton(
                          onPressed: onDelete,
                          icon: Icon(
                            FontAwesome.close,
                            color: primaryColor,
                            size: 16,
                          ),
                        )
                    ],
                  ),
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
                        Column(
                          children: <Widget>[
                            if (this.type == PRODUCT_TYPE_SIMPLE &&
                                this.hideQuantityInput != true)
                              QuantityInput(
                                  minQuantity: this.minQuantity,
                                  onQuantityChanged: this.onQuantityChanged,
                                  addItem: this.addItem,
                                  removeItem: this.removeItem,
                                  quantity: this.quantity != null
                                      ? this.quantity
                                      : 0),
                            if (this.type == PRODUCT_TYPE_VARIABLE &&
                                this.hideQuantityInput != true)
                              Text("x " + this.quantity?.toString()),
                            if (this.type == PRODUCT_TYPE_VARIABLE &&
                                this.hideQuantityInput != true)
                              InkWell(
                                onTap: this.onEditQuantity,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              )
                          ],
                        )
                      ])
                ]),
          )
        ]),
      ),
    );
  }
}
