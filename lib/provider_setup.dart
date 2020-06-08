import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/services/alert_service.dart';
import 'core/services/dialog_service.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: AlertService()),
  Provider.value(value: DialogService()),
];

List<SingleChildWidget> dependentServices = [];

List<SingleChildWidget> uiConsumableProviders = [];
