import 'package:flutter/material.dart';

class ShippingSummary extends StatelessWidget {
  final String country;
  final String shippingMethod;
  final String estimatedPrice;
  final String estimatedDeliveryTime;
  final Function onPressed;

  const ShippingSummary(
      {Key key,
      this.country,
      this.shippingMethod,
      this.estimatedPrice,
      this.estimatedDeliveryTime,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      KeyValue(
                        keyString: "Shipping :",
                        valueString: this.estimatedPrice,
                      ),
                      KeyValue(
                        keyString: "To :",
                        valueString: this.country,
                      ),
                      KeyValue(
                          keyString: "Shipping method : ",
                          valueString: this.shippingMethod),
                      KeyValue(
                          keyString: "Est delivery : ",
                          valueString: this.estimatedDeliveryTime),
                    ]),
              ),
              Icon(
                Icons.chevron_right,
              )
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
