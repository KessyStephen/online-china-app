import 'package:online_china_app/core/models/shipping_details.dart';
import 'package:online_china_app/core/services/account_service.dart';
import 'package:online_china_app/core/services/banner_service.dart';
import 'package:online_china_app/core/services/cart_service.dart';
import 'package:online_china_app/core/services/category_service.dart';
import 'package:online_china_app/core/services/favorite_service.dart';
import 'package:online_china_app/core/services/home_service.dart';
import 'package:online_china_app/core/services/order_service.dart';
import 'package:online_china_app/core/services/product_service.dart';
import 'package:online_china_app/core/services/settings_service.dart';
import 'package:online_china_app/core/services/shipping_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/models/user.dart';
import 'core/services/alert_service.dart';
import 'core/services/api.dart';
import 'core/services/authentication_service.dart';
import 'core/services/dialog_service.dart';
import 'core/services/navigation_service.dart';
import 'core/services/secure_storage_service.dart';
import 'core/services/startup_service.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: SecureStorageService()),
  Provider.value(value: NavigationService()),
  Provider.value(value: AlertService()),
  Provider.value(value: DialogService()),
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider3<SecureStorageService, NavigationService, AlertService, Api>(
    update: (context, storageService, navigationService, alertService, api) =>
        Api(
            storageService: storageService,
            navigationService: navigationService,
            alertService: alertService),
  ),
  ProxyProvider2<Api, AlertService, SettingsService>(
    update: (context, api, alertService, settingsService) =>
        SettingsService(api: api, alertService: alertService),
  ),
  ProxyProvider3<Api, AlertService, SecureStorageService, FavoriteService>(
    update: (context, api, alertService, storageService, favoriteService) =>
        FavoriteService(
            api: api,
            alertService: alertService,
            storageService: storageService),
  ),
  ProxyProvider2<Api, AlertService, BannerService>(
    update: (context, api, alertService, bannerService) =>
        BannerService(api: api, alertService: alertService),
  ),
  ProxyProvider2<Api, AlertService, CategoryService>(
    update: (context, api, alertService, categoryService) =>
        CategoryService(api: api, alertService: alertService),
  ),
  ProxyProvider4<Api, AlertService, CategoryService, SettingsService,
      ShippingService>(
    update: (context, api, alertService, categoryService, settingsService,
            shippingService) =>
        ShippingService(
            api: api,
            alertService: alertService,
            categoryService: categoryService,
            settingsService: settingsService),
  ),
  ProxyProvider4<Api, AlertService, SecureStorageService, NavigationService,
      AuthenticationService>(
    update: (context, api, alertService, storageService, navigationService,
            authenticationService) =>
        AuthenticationService(
            api: api,
            alertService: alertService,
            storageService: storageService,
            navigationService: navigationService),
  ),
  ProxyProvider<AuthenticationService, StartUpService>(
    update: (context, authenticationService, startupService) =>
        StartUpService(authenticationService: authenticationService),
  ),
  ProxyProvider4<Api, AlertService, SettingsService, ShippingService,
      CartService>(
    update: (context, api, alertService, settingsService, shippingService,
            cartService) =>
        CartService(
            api: api,
            alertService: alertService,
            settingsService: settingsService,
            shippingService: shippingService),
  ),
  ProxyProvider3<Api, AlertService, CartService, OrderService>(
    update: (context, api, alertService, cartService, orderService) =>
        OrderService(
            api: api, alertService: alertService, cartService: cartService),
  ),
  // ProxyProvider3<Api, AlertService, CartService, ProductService>(
  //   update: (context, api, alertService, cartService, productService) =>
  //       ProductService(
  //           api: api, alertService: alertService, cartService: cartService),
  // ),
  ProxyProvider5<Api, AlertService, CartService, FavoriteService,
      CategoryService, ProductService>(
    update: (context, api, alertService, cartService, favoriteService,
            categoryService, productService) =>
        ProductService(
            api: api,
            alertService: alertService,
            cartService: cartService,
            favoriteService: favoriteService,
            categoryService: categoryService),
  ),
  ProxyProvider4<OrderService, CartService, SecureStorageService,
      AuthenticationService, AccountService>(
    update: (context, orderService, cartService, storageService,
            authenticationService, accountService) =>
        AccountService(
            orderService: orderService,
            storageService: storageService,
            cartService: cartService,
            authenticationService: authenticationService),
  ),
  ProxyProvider6<Api, AlertService, ProductService, CategoryService,
      BannerService, SettingsService, HomeService>(
    update: (context, api, alertService, productService, categoryService,
            bannerService, settingsService, homeService) =>
        HomeService(
            api: api,
            alertService: alertService,
            productService: productService,
            categoryService: categoryService,
            bannerService: bannerService,
            settingsService: settingsService),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<User>(
    updateShouldNotify: (User var1, User var2) => true,
    initialData: User.initial(),
    create: (context) =>
        Provider.of<AuthenticationService>(context, listen: false).user,
  ),
  StreamProvider<ShippingDetails>(
    updateShouldNotify: (ShippingDetails var1, ShippingDetails var2) => true,
    initialData: ShippingDetails.initial(),
    create: (context) => Provider.of<CartService>(context, listen: false).user,
  )
];
