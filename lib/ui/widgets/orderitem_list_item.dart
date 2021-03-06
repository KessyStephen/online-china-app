import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';

class OrderItemListItem extends StatelessWidget {
  final String subtitle;
  final String title;
  final String price;
  final int quantity;
  final String imageUrl;
  final Function onPressed;

  const OrderItemListItem(
      {Key key,
      this.subtitle,
      this.title,
      this.price,
      this.quantity,
      this.imageUrl,
      this.onPressed})
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
                      imageUrl: this.imageUrl,
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
                  if (this.title != null)
                    Text(this.title != null ? this.title : ""),
                  if (this.subtitle != null)
                    SizedBox(
                      height: 5,
                    ),
                  if (this.subtitle != null)
                    Text(this.subtitle != null ? this.subtitle : ""),
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
                        Text(
                          this.quantity != null ? "x ${this.quantity}" : "",
                          style: TextStyle(fontSize: 14),
                        ),
                      ])
                ]),
          )
        ]),
      ),
    );
  }
}
