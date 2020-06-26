import 'package:online_china_app/core/services/cart_service.dart';
import 'package:online_china_app/core/services/category_service.dart';
import 'package:online_china_app/core/services/order_service.dart';
import 'package:online_china_app/core/services/product_service.dart';
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
  ProxyProvider2<Api, AlertService, CategoryService>(
    update: (context, api, alertService, categoryService) =>
        CategoryService(api: api, alertService: alertService),
  ),
  ProxyProvider2<Api, AlertService, ProductService>(
    update: (context, api, alertService, productService) =>
        ProductService(api: api, alertService: alertService),
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
  ProxyProvider2<Api, AlertService, OrderService>(
    update: (context, api, alertService, orderService) =>
        OrderService(api: api, alertService: alertService),
  ),
  ProxyProvider2<Api, AlertService, CartService>(
    update: (context, api, alertService, cartService) =>
        CartService(api: api, alertService: alertService),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<User>(
    updateShouldNotify: (User var1, User var2) => true,
    initialData: User.initial(),
    create: (context) =>
        Provider.of<AuthenticationService>(context, listen: false).user,
  )
];
