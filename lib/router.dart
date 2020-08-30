import 'package:flutter/material.dart';
import 'package:online_china_app/ui/views/account_view.dart';
import 'package:online_china_app/ui/views/country_code_picker.dart';
import 'package:online_china_app/ui/views/favorite_list_view.dart';
import 'package:online_china_app/ui/views/home_view.dart';
import 'package:online_china_app/ui/views/in_app_webview.dart';
import 'package:online_china_app/ui/views/login_view.dart';
import 'package:online_china_app/ui/views/order/confirm_order_view.dart';
import 'package:online_china_app/ui/views/order/order_address.dart';
import 'package:online_china_app/ui/views/order/order_detail_view.dart';
import 'package:online_china_app/ui/views/product_search_view.dart';
import 'package:online_china_app/ui/views/registration/change_password_view.dart';
import 'package:online_china_app/ui/views/registration/register_phone.dart';
import 'package:online_china_app/ui/views/registration/user_info.dart';
import 'package:online_china_app/ui/views/registration/verify_otp.dart';
import 'package:online_china_app/ui/views/reset_password.dart';
import 'package:online_china_app/ui/views/product_detail_view.dart';
import 'package:online_china_app/ui/views/product_list_view.dart';
import 'package:online_china_app/ui/views/subcategory_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => HomeView(),
            settings: RouteSettings(arguments: settings.arguments));
        break;

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginView());
        break;

      case '/register':
        return MaterialPageRoute(
            builder: (_) => RegisterView(),
            settings: RouteSettings(arguments: settings.arguments));

      case '/verify':
        return MaterialPageRoute(builder: (_) => VerifyOtpView());

      case '/user_info':
        return MaterialPageRoute(builder: (_) => FinallyUserInfoView());

      case '/reset_password':
        return MaterialPageRoute(builder: (_) => ResetPassword());

      case '/change_password':
        return MaterialPageRoute(builder: (_) => ChangePasswordView());

      case '/country_code_picker':
        return MaterialPageRoute(
            builder: (_) => CountryCodePicker(),
            settings: RouteSettings(arguments: settings.arguments));

      case '/product_detail':
        return MaterialPageRoute(
            builder: (_) => ProductDetailView(),
            settings: RouteSettings(arguments: settings.arguments));
        break;
      case '/product_description_full':
        return MaterialPageRoute(
            builder: (_) => InAppWebview(),
            settings: RouteSettings(arguments: settings.arguments));
        break;
      case '/product_list':
        return MaterialPageRoute(
            builder: (_) => ProductListView(),
            settings: RouteSettings(arguments: settings.arguments));
        break;
      case '/favorite_list':
        return MaterialPageRoute(
            builder: (_) => FavoriteListView(),
            settings: RouteSettings(arguments: settings.arguments));
        break;
      case '/subcategories':
        return MaterialPageRoute(
            builder: (_) => SubCategoryView(),
            settings: RouteSettings(arguments: settings.arguments));
        break;
      case '/confirm_order':
        return MaterialPageRoute(
            builder: (_) => ConfirmOrderView(),
            settings: RouteSettings(arguments: settings.arguments));
        break;
      case '/order_address':
        return MaterialPageRoute(
            builder: (_) => OrderAddressView(),
            settings: RouteSettings(arguments: settings.arguments));
        break;
      case '/order_detail':
        return MaterialPageRoute(
            builder: (_) => OrderDetailView(),
            settings: RouteSettings(arguments: settings.arguments));
        break;
      case '/account':
        return MaterialPageRoute(
            builder: (_) => AccountView(),
            settings: RouteSettings(arguments: settings.arguments));
        break;
      case '/search':
        return MaterialPageRoute(
            builder: (_) => ProductSearchView(),
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
