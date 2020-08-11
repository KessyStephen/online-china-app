import 'package:flutter/material.dart';
import 'package:online_china_app/ui/widgets/quantity_input.dart';

class ProductOptionListItem extends StatelessWidget {
  final String title;
  final String price;
  final int quantity;
  final String imageUrl;
  final bool hideQuantityInput;
  final Function addItem;
  final Function removeItem;
  final Function onPressed;
  final ValueChanged<int> onQuantityChanged;

  const ProductOptionListItem(
      {Key key,
      this.title,
      this.price,
      this.quantity,
      this.imageUrl,
      this.hideQuantityInput,
      this.addItem,
      this.removeItem,
      this.onPressed,
      this.onQuantityChanged})
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
          // Container(
          //     height: 80,
          //     width: 80,
          //     margin: const EdgeInsets.only(right: 8),
          //     child: this.imageUrl != null
          //         ? CachedNetworkImage(
          //             imageUrl: this.imageUrl != null ? this.imageUrl : "",
          //             fit: BoxFit.cover,
          //             placeholder: (context, url) => Image.asset(
          //               PLACEHOLDER_IMAGE,
          //               fit: BoxFit.cover,
          //             ),
          //           )
          //         : Image.asset(
          //             PLACEHOLDER_IMAGE,
          //             fit: BoxFit.cover,
          //           )),
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
                              minQuantity:
                                  0, //allow zero, for variable products
                              onQuantityChanged: this.onQuantityChanged,
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
