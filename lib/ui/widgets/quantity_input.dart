import 'package:flutter/material.dart';

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
