import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/viewmodels/views/auth_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:provider/provider.dart';

import '../../base_widget.dart';

class RegisterView extends StatelessWidget {
  String phone = "";

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    return BaseView<AuthModel>(
      model: AuthModel(authenticationService: Provider.of(context)),
      onModelReady: (model) async {
        if (data != null) {
          model.setResetPasswordFlag();
        }
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    model.isResetPassword ? 'Phone' : 'Register',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    'Enter your phone number',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/country_code_picker',
                            arguments: {'next': 'register'});
                      },
                      child: Container(
                        width: 200,
                        margin: EdgeInsets.only(top: 12),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1.0, color: primaryColor)),
                        child: model.countryCode != null
                            ? Text(model.countryCode.phonePrefix)
                            : Text('+255'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      onChanged: (value) {
                        model.setPhoneNumber(value);
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: 'Phone number',
                          labelStyle: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
            model.state == ViewState.Busy
                ? Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: BigButton(
                      buttonTitle: "Continue",
                      functionality: () async {
                        if (await model.requestOtp(
                            phone: model.phone,
                            otpFor:
                                model.isResetPassword ? 'RESET' : 'REGISTER'))
                          Navigator.pushReplacementNamed(context, '/verify');
                        print(model.countryCode);
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
