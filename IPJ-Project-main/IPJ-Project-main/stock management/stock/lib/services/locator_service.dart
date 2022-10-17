import 'package:get_it/get_it.dart';

import 'navigation_and_dialog_service.dart';

final locator = GetIt.instance;

void setupLocator() async {
  locator.registerLazySingleton<NavigationAndDialogService>(
      () => NavigationAndDialogService());
}
