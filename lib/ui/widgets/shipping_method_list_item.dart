import 'package:flutter/material.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';

class ShippingMethodListItem extends StatelessWidget {
  final String shippingMethod;
  final String estimatedPrice;
  final String estimatedDeliveryTime;
  final bool checked;
  final Function onPressed;

  const ShippingMethodListItem(
      {Key key,
      this.shippingMethod,
      this.estimatedPrice,
      this.estimatedDeliveryTime,
      this.checked,
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
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            KeyValue(
                                keyString: "by",
                                valueString: this.shippingMethod),
                            SizedBox(
                              width: 20,
                            ),
                            KeyValue(
                              keyString: "Est Price :",
                              valueString: this.estimatedPrice,
                            ),
                          ]),
                      SizedBox(
                        height: 6,
                      ),
                      Text("Estimated Delivery : ${this.estimatedDeliveryTime}")
                    ]),
              ),
              Icon(Icons.check,
                  color: this.checked ? primaryColor : Colors.transparent)
            ],
          )),
    );
  }
}

class KeyValue extends StatelessWidget {
  final String keyString;
  final String valueString;
  const KeyValue({
    Key key,
    this.keyString,
    this.valueString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(this.keyString != null ? this.keyString + " " : ""),
        Text(
          this.valueString != null ? this.valueString : "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
