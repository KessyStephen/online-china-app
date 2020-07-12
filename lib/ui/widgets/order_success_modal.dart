import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/big_button_outline.dart';

class OrderSuccessModal extends StatelessWidget {
  final Function onGetInvoice;

  const OrderSuccessModal({Key key, this.onGetInvoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Order Status',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  FontAwesome.times,
                  color: primaryColor,
                ),
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Order Successfully Placed!',
            style: const TextStyle(fontSize: 16.0),
          ),
          SizedBox(
            height: 10,
          ),
          Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 70,
          ),
          SizedBox(
            height: 10,
          ),
          BigButton(
              buttonTitle: 'GO TO INVOICE', functionality: this.onGetInvoice),
          SizedBox(
            height: 8,
          ),
          Text('OR'),
          SizedBox(
            height: 8,
          ),
          BigButtonOutline(
            buttonTitle: 'GO SHOPPING',
            functionality: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
