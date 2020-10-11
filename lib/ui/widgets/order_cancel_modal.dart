import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/big_button_outline.dart';

class OrderCancelModal extends StatelessWidget {
  final Function onCancelOrder;

  const OrderCancelModal({Key key, this.onCancelOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      padding: EdgeInsets.all(16),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Confirm',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  FontAwesome.times,
                  color: primaryColor,
                ),
                onPressed: () {
                  // Get.back();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/", (Route<dynamic> route) => false,
                      arguments: {"switchToIndex": ORDERS_INDEX});
                },
              )
            ],
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Text(
            'Are you sure you want to cancel order?',
            style: const TextStyle(fontSize: 16.0),
          ),
          SizedBox(
            height: 10,
          ),
          // Icon(
          //   Icons.check_circle_outline,
          //   color: Colors.green,
          //   size: 70,
          // ),
          SizedBox(
            height: 10,
          ),

          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: BigButton(
                    buttonTitle: 'DISMISS', functionality: () => Get.back()),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: BigButtonOutline(
                  buttonTitle: 'YES',
                  functionality: this.onCancelOrder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
