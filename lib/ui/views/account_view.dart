import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/user.dart';
import 'package:online_china_app/core/viewmodels/views/account_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<AccountModel>(
      model: AccountModel(accountService: Provider.of(context)),
      onModelReady: (model) => {},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          // elevation: 0,
          // backgroundColor: Colors.transparent,
          title: Text(
            "Account",
            // style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                decoration:
                    BoxDecoration(border: Border.all(color: primaryColor)),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 5.0,
                    ),
                    Icon(
                      Icons.person,
                      color: primaryColor,
                      size: 60.0,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Provider.of<User>(context).name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Provider.of<User>(context).phone,
                          style: TextStyle(fontWeight: FontWeight.w300),
                        )
                      ],
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.lock_outline,
                  color: primaryColor,
                  size: 30.0,
                ),
                title: Text('Change password'),
                onTap: () {
                  Navigator.pushNamed(context, '/register',
                      arguments: {'reset_password': true});
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.favorite_border,
                  color: primaryColor,
                  size: 30.0,
                ),
                title: Text('Wishlist'),
              ),
              ListTile(
                leading: Icon(
                  Icons.help_outline,
                  color: primaryColor,
                  size: 30.0,
                ),
                title: Text('FAQ'),
              ),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: primaryColor,
                  size: 30.0,
                ),
                title: Text('About'),
              ),
              ListTile(
                leading: Icon(
                  Icons.launch,
                  color: primaryColor,
                  size: 30.0,
                ),
                title: Text('Logout'),
                onTap: () {
                  model.logout();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
