import 'package:flutter/material.dart';
import 'package:online_china_app/ui/views/home_view.dart';
import 'package:online_china_app/ui/views/product_detail_view.dart';
import 'package:online_china_app/ui/views/product_list_view.dart';
import 'package:online_china_app/ui/views/subcategory_view.dart';
import 'package:online_china_app/ui/widgets/product_list_item.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeView());
        break;
      case '/product_detail':
        return MaterialPageRoute(
            builder: (_) => ProductDetailView(),
            settings: RouteSettings(arguments: settings.arguments));
        break;
      case '/product_list':
        return MaterialPageRoute(
            builder: (_) => ProductListView(),
            settings: RouteSettings(arguments: settings.arguments));
        break;
      case '/subcategories':
        return MaterialPageRoute(
            builder: (_) => SubCategoryView(),
            settings: RouteSettings(arguments: settings.arguments));
        break;
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
