import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/viewmodels/views/auth_model.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:provider/provider.dart';

import '../../base_widget.dart';

class FinallyUserInfoView extends StatefulWidget {
  @override
  _FinallyUserInfoViewState createState() => _FinallyUserInfoViewState();
}

class _FinallyUserInfoViewState extends State<FinallyUserInfoView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthModel>(
      model: AuthModel(authenticationService: Provider.of(context)),
      onModelReady: (model) => {},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: 30,
            ),
          ),
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
                    'Finally',
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
                    'Add your personal information',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _fullNameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter full name';
                        }

//                        if (value.length >= 3) {
//                          return 'Full name must be 3 more characters';
//                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Full name',
                          labelStyle: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      showCursor: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        }

//                        if (value.length >= 6) {
//                          return 'Password must 6 or more characters';
//                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500),
                        border: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.grey)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Confirm password doesnt match password';
                        }
                        return null;
                      },
                      obscureText: true,
                      showCursor: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500),
                        border: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.grey)),
                      ),
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
                      buttonTitle: "Submit",
                      functionality: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          if (await model.register(
                              phone: model.phone,
                              name: _fullNameController.text,
                              password: _passwordController.text,
                              confirmPassword: _confirmPasswordController.text,
                              countryCode: model.countryCode.code,
                              verificationId: model.verificationId)) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        }
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
