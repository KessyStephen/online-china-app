import 'package:get/get.dart';
import 'package:online_china_app/core/services/authentication_service.dart';
import 'package:online_china_app/core/services/cart_service.dart';
import 'package:online_china_app/core/services/order_service.dart';
import 'package:online_china_app/core/services/secure_storage_service.dart';

class AccountService {
  final OrderService _orderService;
  final CartService _cartService;
  final SecureStorageService _storageService;
  final AuthenticationService _authenticationService;

  AccountService(
      {OrderService orderService,
      CartService cartService,
      SecureStorageService storageService,
      AuthenticationService authenticationService})
      : _orderService = orderService,
        _cartService = cartService,
        _storageService = storageService,
        _authenticationService = authenticationService;

  void clearData() async {
    await _storageService.clearAllData();
    _cartService.clearCartData();
    _orderService.clearOrderData(removeOrders: true);
    await _authenticationService.addUserToStream();
    Get.offNamed('/login');
  }
}
