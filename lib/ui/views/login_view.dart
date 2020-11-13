import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/viewmodels/views/auth_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:provider/provider.dart';

import 'base_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _hidePassword = true;

  void _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthModel>(
      model: AuthModel(authenticationService: Provider.of(context)),
      onModelReady: (model) async {
        if (model.countryCode == null) await model.getCountryCodes();
      },
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        'Welcome back, login to continue',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  alignment: Alignment.center,
                  child: Image(
                    height: 200.0,
                    image: AssetImage('assets/images/logo_and_label.png'),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/country_code_picker',
                                      arguments: {'next': 'login'});
                                },
                                child: Container(
                                  width: 200,
                                  margin: EdgeInsets.only(top: 12),
                                  padding: EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: primaryColor)),
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
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Phone',
                                    labelStyle: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 18.0,
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _hidePassword,
                          showCursor: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w500),
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey)),
                            suffixIcon: IconButton(
                              onPressed: _toggleHidePassword,
                              icon: Icon(_hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          model.setResetPasswordFlag();
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 15.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Forgot Password? Reset',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          model.setNotResetPasswordFlag();
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 15.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text('Register here!')
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          model.setNotResetPasswordFlag();
                          // Navigator.pushReplacementNamed(context, '/');
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/home", (Route<dynamic> route) => false,
                              arguments: {"switchToIndex": 0});
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 15.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Continue without Logging in",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: BigButton(
                                  buttonTitle: "Login",
                                  functionality: () async {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      if (await model.login(
                                          phone: _phoneController.text,
                                          password: _passwordController.text)) {
                                        // bool isBasketFull =
                                        //     await model.checkIfBasketIsFull();
                                        Navigator.pushReplacementNamed(
                                            context, '/');
                                      }
                                    }
                                  },
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
