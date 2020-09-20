import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityInput extends StatefulWidget {
  final Function addItem;
  final Function removeItem;
  final int minQuantity;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  QuantityInput(
      {this.addItem,
      this.removeItem,
      this.quantity,
      this.minQuantity,
      this.onQuantityChanged});

  @override
  _QuantityInputState createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  //int value;
  TextEditingController _controller = TextEditingController()..text = '';

  @override
  Widget build(BuildContext context) {
    _controller.value = TextEditingValue(
        text: "${widget.quantity}",
        selection: TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length)));

    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              if (widget.onQuantityChanged != null &&
                  _controller.text != null &&
                  _controller.text.isNotEmpty) {
                var intVal = int.tryParse(_controller.text) - 1;

                if (widget.minQuantity != null &&
                    intVal <= widget.minQuantity) {
                  intVal = widget.minQuantity;
                }

                _controller.text = "$intVal";
                widget.onQuantityChanged(intVal);
                _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length));
              }
            },
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
          // Text(this.quantity.toString()),
          Container(
            height: 42,
            width: 40,
            child: Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: _controller,
                maxLines: 1,

                // maxLength:
                //     3, //setting maximum length of the textfieldmaxLengthEnforced:
                // maxLengthEnforced: true, //prevent the user from further typing
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                autocorrect: false,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                // textAlign: TextAlign.end,
                toolbarOptions: ToolbarOptions(
                  cut: true,
                  copy: false,
                  selectAll: true,
                  paste: false,
                ),
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    // contentPadding: EdgeInsets.only(bottom: 5),
                    contentPadding: EdgeInsets.only(bottom: 0),
                    counterText: "",
                    labelText: "",
                    hintText: ""),

                style: TextStyle(
                  fontSize: 16.0,
                ),
                onChanged: (val) {
                  var intVal = int.tryParse(val);
                  widget.onQuantityChanged(intVal);
                },
                onSubmitted: (value) {},
                onEditingComplete: () {},
              ),
            ),
          ),
          Container(
            width: 1,
            margin: const EdgeInsets.only(left: 8),
            color: Colors.grey,
            child: const Text(""),
          ),
          InkWell(
            onTap: () {
              if (widget.onQuantityChanged != null &&
                  _controller.text != null &&
                  _controller.text.isNotEmpty) {
                var intVal = int.tryParse(_controller.text) + 1;
                _controller.text = "$intVal";
                widget.onQuantityChanged(intVal);
                _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length));
              }
            },
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
