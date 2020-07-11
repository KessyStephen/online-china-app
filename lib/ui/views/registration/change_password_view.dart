import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/viewmodels/views/auth_model.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:provider/provider.dart';

import '../../base_widget.dart';

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
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
                    'Change Password',
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
                    'Enter your current password and new password',
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
                      controller: _currentPasswordController,
                      obscureText: true,
                      showCursor: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter current password';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Current Password',
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
                          return 'Please enter new password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'New Password',
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
                          return 'Confirm password doesnt match new password';
                        }
                        return null;
                      },
                      obscureText: true,
                      showCursor: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
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

                          if (await model.changePassword(
                            password: _currentPasswordController.text,
                            newPassword: _passwordController.text,
                            confirmNewPassword: _confirmPasswordController.text,
                          )) {
                            model.logout();
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
