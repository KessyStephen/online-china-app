import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/viewmodels/views/home_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/views/tabs/cart_tab.dart';
import 'package:online_china_app/ui/views/tabs/category_tab.dart';
import 'package:online_china_app/ui/views/tabs/home_tab.dart';
import 'package:online_china_app/ui/views/tabs/orders_tab.dart';

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
    return BaseView<HomeModel>(
      model: HomeModel(),
      onModelReady: (model) async {
        // await model.handleStartUpLogic();
      },
      builder: (context, model, child) => BusyOverlay(
        show: model.state == ViewState.Busy,
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
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                title: Text('Categories'),
              ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
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
