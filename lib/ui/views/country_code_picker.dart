import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/viewmodels/views/auth_model.dart';
import 'package:online_china_app/ui/base_widget.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:provider/provider.dart';

class CountryCodePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<AuthModel>(
      model: AuthModel(authenticationService: Provider.of(context)),
      onModelReady: (model) async {
        if (model.countryCodes.length == 0) await model.getCountryCodes();
      },
      builder: (context, model, child) => Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                    color: primaryColor,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                    color: primaryColor,
                    child: Text(
                      'Done',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                  )
                ],
              ),
              Container(
                child: TextField(
                  onChanged: (String value) {
//                    if(value.length >=3){
                      model.searchForCountry(value);
//                    }
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Container(
                          color: model.countryCode?.country == model.searchResults[index].country ? Colors.redAccent : Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(model.searchResults[index].country),
                              Text(model.searchResults[index].code)
                            ],
                          ),
                        ),
                        onTap: () {
                          model.setCountryCode(model.searchResults[index]);
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
