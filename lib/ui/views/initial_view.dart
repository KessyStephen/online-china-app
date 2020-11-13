import 'package:flutter/material.dart';
import 'package:online_china_app/core/viewmodels/views/home_model.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class InitialView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
        model: HomeModel(homeService: Provider.of(context)),
        onModelReady: (model) async {
          //get this first it has commissionRates for products
          await model.getAllCategories(hideLoading: true);

          await model.getHomeItems(perPage: 30, page: 1);

          // await model.getExchangeRates();

          // await model.getCompanySettings();

          // if (model.bestSellingProducts == null ||
          //     model.bestSellingProducts.length == 0) {
          //   model.getBestSellingProducts();
          // }
          // model.getBestSellingProducts();

          // if (model.newArrivalProducts == null ||
          //     model.newArrivalProducts.length == 0) {
          //   model.getNewArrivalProducts();
          // }
          // model.getNewArrivalProducts();

          if (model.favorites == null || model.favorites.length == 0) {
            model.getFavorites();
          }

          Navigator.pushReplacementNamed(context, "/home");
        },
        builder: (context, model, child) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: SafeArea(
                  child: Stack(
                children: <Widget>[
                  Center(
                      child: Container(
                    height: 100,
                    child: Image.asset(
                      "assets/images/logo_and_label.png",
                      fit: BoxFit.contain,
                    ),
                  )),
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    alignment: Alignment.bottomCenter,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              )),
            ));
  }
}
