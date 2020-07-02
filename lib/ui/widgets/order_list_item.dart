import 'package:flutter/material.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';

class OrderListItem extends StatelessWidget {
  final String orderID;
  final String orderDate;
  final String paymentStatus;
  final String itemCount;

  final String price;
  final Function onPressed;

  const OrderListItem(
      {Key key,
      this.orderID,
      this.orderDate,
      this.paymentStatus,
      this.itemCount,
      this.price,
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
          child: Column(children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Order ID: " + this.orderID),
                  Text(this.orderDate)
                ]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(this.paymentStatus),
                    Text(this.itemCount != null ? this.itemCount : "")
                  ]),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(this.price),
                  const Icon(
                    Icons.chevron_right,
                    color: primaryColor,
                  )
                ])
          ])),
    );
  }
}
