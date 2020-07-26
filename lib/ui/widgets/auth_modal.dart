import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:online_china_app/core/viewmodels/views/auth_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';
import 'big_button.dart';
import 'big_button_outline.dart';

class AuthModalWidget extends StatelessWidget {
  final String message;
  final String subText;
  final bool productsInBasket;

  const AuthModalWidget(
      {Key key, this.message, this.subText, this.productsInBasket = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthModel>(
        model: AuthModel(authenticationService: Provider.of(context)),
        onModelReady: (model) => {},
        builder: (context, model, child) => Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Login to continue',
                        style: TextStyle(
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
                  BigButton(
                    buttonTitle: 'Login',
                    functionality: () {
                      if (productsInBasket)
                        model.setIsBasketFull(productsInBasket);
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      Text('OR'),
                      Divider(
                        height: 1,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  BigButtonOutline(
                    buttonTitle: 'Register',
                    functionality: () {
                      if (productsInBasket)
                        model.setIsBasketFull(productsInBasket);
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                  ),
                ],
              ),
            ));
  }
}
