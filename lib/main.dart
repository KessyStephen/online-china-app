import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/router.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:provider/provider.dart';
import 'core/managers/alert_manager.dart';
import 'core/managers/dialog_manager.dart';
import 'provider_setup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: APP_NAME,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.transparent,
          primaryColor: primaryColor,
          accentColor: Color(0xff2ECC71),
          hintColor: Color(0xff707070),
        ),
        initialRoute: '/',
        navigatorKey: Get.key,
        onGenerateRoute: Router.generateRoute,
        builder: (context, widget) => Navigator(
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => SafeArea(
              child: DialogManager(
                dialogService: Provider.of(context),
                child: AlertManager(
                  child: widget,
                  alertService: Provider.of(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
