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
        backgroundColor: Theme.of(context).backgroundColor,
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
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(112, 112, 112, 1.0))),
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
              SettingListItem(
                title: "Wishlist",
                leading: const Icon(
                  Icons.favorite_border,
                  color: primaryColor,
                  size: 30.0,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: primaryColor,
                  size: 30.0,
                ),
              ),
              SettingListItem(
                title: 'Change password',
                leading: const Icon(
                  Icons.lock_outline,
                  color: primaryColor,
                  size: 30.0,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: primaryColor,
                  size: 30.0,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/register',
                      arguments: {'reset_password': true});
                },
              ),
              SettingListItem(
                title: 'Currency',
                leading: const Icon(
                  Icons.euro_symbol,
                  color: primaryColor,
                  size: 30.0,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: primaryColor,
                  size: 30.0,
                ),
              ),
              SettingListItem(
                title: 'Language',
                leading: const Icon(
                  Icons.language,
                  color: primaryColor,
                  size: 30.0,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: primaryColor,
                  size: 30.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 12),
                child: Container(
                  height: 1,
                  color: Color.fromRGBO(112, 112, 112, 1.0),
                ),
              ),
              SettingListItem(
                title: 'FAQ',
                leading: const Icon(
                  Icons.help_outline,
                  color: primaryColor,
                  size: 30.0,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: primaryColor,
                  size: 30.0,
                ),
              ),
              SettingListItem(
                  title: 'About',
                  leading: const Icon(
                    Icons.info_outline,
                    color: primaryColor,
                    size: 30.0,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: primaryColor,
                    size: 30.0,
                  )),
              SettingListItem(
                title: 'Logout',
                leading: const Icon(
                  Icons.launch,
                  color: primaryColor,
                  size: 30.0,
                ),
                onPressed: () {
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

class SettingListItem extends StatelessWidget {
  final String title;
  final Widget leading;
  final Widget trailing;
  final Function onPressed;
  const SettingListItem(
      {Key key, this.title, this.leading, this.trailing, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Color(0xffdfe4ea),
            blurRadius: 10.0, // has the effect of softening the shadow
            // spreadRadius: 8.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              10.0, // vertical, move down 10
            ),
          )
        ]),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: this.leading,
          title: Text(this.title != null ? this.title : ""),
          trailing: this.trailing,
        ),
      ),
    );
  }
}
