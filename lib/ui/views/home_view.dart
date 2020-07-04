import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/viewmodels/views/startup_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/views/tabs/cart_tab.dart';
import 'package:online_china_app/ui/views/tabs/category_tab.dart';
import 'package:online_china_app/ui/views/tabs/home_tab.dart';
import 'package:online_china_app/ui/views/tabs/orders_tab.dart';
import 'package:provider/provider.dart';

import 'base_view.dart';
import 'busy_overlay.dart';

class HomeView extends StatelessWidget {
  final List<Widget> _tabViews = [
    HomeTabView(),
    CategoryTabView(),
    CartTabView(),
    OrdersTabView(),
  ];

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    var switchToIndex = params != null ? params['switchToIndex'] : null;

    return BaseView<StartUpModel>(
      model: StartUpModel(
        startUpService: Provider.of(context),
      ),
      onModelReady: (model) async {
        await model.handleStartUpLogic();

        if (switchToIndex != null) {
          await model.navigateToTab(switchToIndex);
        }
      },
      builder: (context, model, child) => BusyOverlay(
        show: false,
        child: Scaffold(
          body: SafeArea(
            child: _tabViews[model.currentIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: model.currentIndex,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 8.0,
            unselectedLabelStyle: TextStyle(color: Colors.grey),
            onTap: (index) => model.navigateToTab(index),
            items: [
              new BottomNavigationBarItem(
                icon: Icon(Entypo.home),
                title: Text('Home'),
              ),
              new BottomNavigationBarItem(
                icon: Icon(Ionicons.md_grid),
                title: Text('Categories'),
              ),
              new BottomNavigationBarItem(
                icon: Icon(AntDesign.shoppingcart),
                title: Text('My Items'),
              ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted), //list_alt
                title: Text('Orders'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
