import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/router.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'core/managers/alert_manager.dart';
import 'core/managers/dialog_manager.dart';
import 'provider_setup.dart';
import 'package:online_china_app/core/enums/notification.dart';

void main() {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  //initialize local notification
  final android = AndroidInitializationSettings('@mipmap/launcher_icon');
  final iOS = IOSInitializationSettings();
  final initSettings = InitializationSettings(android, iOS);
  flutterLocalNotificationsPlugin.initialize(initSettings,
      onSelectNotification: _onSelectNotification);

  runApp(MyApp());
}

Future<void> _onSelectNotification(String json) async {
  // todo: handling clicked notification

  final obj = jsonDecode(json);

  if (obj != null && obj['success']) {
    OpenFile.open(obj['filePath']);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: MaterialApp(
          title: APP_NAME,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            backgroundColor: backgroundColor,
            primaryColor: primaryColor,
            accentColor: primaryColor,
            hintColor: Color(0xff707070),
          ),
          initialRoute: '/',
          navigatorKey: Get.key,
          onGenerateRoute: ShamwaaRouter.generateRoute,
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
      ),
    );
  }
}
