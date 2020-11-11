import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/user.dart';
import 'package:online_china_app/core/viewmodels/views/account_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class AccountView extends StatefulWidget {
  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  String appVersion = "";

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<User>(context);
    return BaseView<AccountModel>(
      model: AccountModel(accountService: Provider.of(context)),
      onModelReady: (model) async {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        setState(() {
          appVersion = packageInfo?.version ?? "";
        });
      },
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
              if (currentUser.isLoggedIn)
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
              if (currentUser.isLoggedIn)
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/favorite_list');
                  },
                ),
              if (currentUser.isLoggedIn)
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
                    Navigator.pushNamed(context, '/change_password');
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
                onPressed: () {
                  Navigator.pushNamed(context, '/currency_list');
                },
              ),
              // SettingListItem(
              //   title: 'Language',
              //   leading: const Icon(
              //     Icons.language,
              //     color: primaryColor,
              //     size: 30.0,
              //   ),
              //   trailing: const Icon(
              //     Icons.chevron_right,
              //     color: primaryColor,
              //     size: 30.0,
              //   ),
              // ),
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
                onPressed: () => Navigator.pushNamed(context, "/in_app_webview",
                    arguments: {"title": "FAQ", "body": _getFAQHTML()}),
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
                ),
                onPressed: () => Navigator.pushNamed(context, "/in_app_webview",
                    arguments: {"title": "About", "body": _getAboutHTML()}),
              ),
              SettingListItem(
                title: currentUser.isLoggedIn ? 'Logout' : "Sign In / Register",
                leading: const Icon(
                  Icons.launch,
                  color: primaryColor,
                  size: 30.0,
                ),
                onPressed: () {
                  model.logout();
                },
              ),
              SettingListItem(
                title: 'Version',
                leading: const Icon(
                  Icons.info_outline,
                  color: primaryColor,
                  size: 30.0,
                ),
                trailing: Text(appVersion),
                onPressed: () => Navigator.pushNamed(context, "/in_app_webview",
                    arguments: {"title": "About", "body": _getAboutHTML()}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFAQHTML() {
    return '''
    <!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
  </head>
  <body>
    <div>
      <h3>What is Shamwaa App?</h3>
      <p>
        is an online platform that provides YOU (our customers) the access to
        buy from different online manufactures and suppliers from china to
        Africa as we take care of everything for you, payment, shipping,
        clearing and delivery!
      </p>

      <h3>How do I contact the customer service?</h3>
      <p>
        Whatsapp: <br />
        +86 132 6805 1716 <br /><br />

        Call: <br />
        +255 659 900 000 <br />
        +255 756 001 001 <br />
        +255 676 888 883 <br /><br />

        E-mail: <br />
        sales@shamwaa.com <br />
        business@shamwaa.com<br /><br />

        Social Media: Instagram, Facebook, WhatsApp
      </p>

      <h3>What are your opening hours?</h3>
      <p>
        The Shamwaa App is an online business, we are open 24/7 throughout the
        year.
      </p>

      <h3>What are the payment methods?</h3>
      <p>
        To make it as easy and convenient for our customers to be able to make
        orders anytime and from anywhere they are in the country. We have
        multiple Payment getaways to pay with You can choose the payment method
        when you are checking out, we accept: <br />
        Mobile Payment  <br />
        TIGO PESA, M-PESA, AIRTEL MONEY to CRDB BANK. <br /><br />

        Credit Card  <br />
        CRDB Bank Transfer to our CRDB Bank Account
      </p>

      <h3>When should I expect my order ?</h3>
      <p>Air cargo is within 10 working days and shipping is 28 days.</p>

      <h3>Where is your office located?</h3>
      <p>
        Our CHINA HEAD QUARTER <br />
        OFFICE is located at: Room 1705,no.8 tongya street,Xicha road,baiyun
        district,Guangzhou. <br /><br />

        Our TANZANIA OFFICE is located at: Sokoine Drive, 22nd <br />
        Floor, Wing A, PSPF Twins Towers, Posta, Dar-es-salaam, Tanzania.
      </p>
    </div>
  </body>
</html>

    ''';
  }

  String _getAboutHTML() {
    return '''
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
  </head>
  <body>
    <div>
      <h3>OUR SHAMWAA APP</h3>
      <p>
        Shamwaa App is a mobile application which can easily be accessed by any
        device capable of accessing the internet. It is developed using
        JavaScript technology and has an easy to use interface making it
        attractive to all. Great emphasis has been placed on making the layout
        clear and user friendly so as to allow ease of navigation between its
        various views and quick access to information by just clicking icons.
        Shamwaa App has built up an online database of over 100,000
        manufacturers of consumer goods and other related products and a network
        of more than 1,000,000 registered potential Suppliers in China.
      </p>

      <h3>OUR SERVICE</h3>
      <p>
        Shamwaa App offers complete import/export services plus inventory
        consulting services. This includes -: <br/>
        <ul>
          <li>Purchasing</li>
          <li>Quality inspection</li>
          <li>Warehousing</li>
          <li>Shipping</li>
          <li>Delivery</li>
        </ul>
      </p>
      <h3>OUR SHAMWAA APP SERVICE FEATURES DESCRIPTION</h3>
      <p>The main services provided by Shamwaa App are:</p>

      <p>
        <strong>Product Search Portal:</strong> A means for customers to browse
        through the app and view pictures, videos, and prices about the
        products.
      </p>

      <p>
        <strong>Product ordering:</strong> A means for customers to make orders
        about products that they have visited.
      </p>

      <p>
        <strong> Invoicing: </strong>A method for users be billed for their
        orders made on the platform
      </p>

      <h3>OUR VISION</h3>
      <p>
        Our vision is to be the one-stop search site for all goods and products
        sourcing and manufacturing service needs in China. We combine the
        efficiency of the web with the personal touch of businesses by helping
        them find the perfect services to bring their businesses to succession.
      </p>

      <h3>OUR MISSION</h3>
      <p>
        Our primary responsibility is to the financial well-being of local
        African businesses, to provide high quality, convenient and
        comprehensive products purchasing experiences to businesses at
        affordable costs.
      </p>
      <p>
        It is the goal of our firm to have 100% customer satisfaction in regards
        to quality, friendliness and time to completion, and discover new ways
        to exceed the expectations of our customers while doing so at the lowest
        possible cost.
      </p>
      <p>
        Shamwaa App will maintain a work environment that is friendly, fair, and
        will provide rewards for creativity and those who help the company carry
        forward to the future.
      </p>
    </div>
  </body>
</html>

''';
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
