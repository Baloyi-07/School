import 'package:backendless_sdk/backendless_sdk.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stock/routes/routes.dart';
import 'package:stock/services/todo_service.dart';
import 'package:stock/services/user_service.dart';

class InitApp {
  static final String apiKeyAndroid = 'C16C03B8-E4CB-4146-80EA-14385F78FE7C';
  static final String apiKeyiOS = '4B95F050-CE6B-4350-AB72-1D6F0EDD5954';
  static final String appID = '4BBDFFEF-DCD0-EF79-FFF5-04796DB45100';

  static void initializeApp(BuildContext context) async {
    await Backendless.initApp(
        applicationId: appID,
        iosApiKey: apiKeyiOS,
        androidApiKey: apiKeyAndroid);
    String result = await context.read<UserService>().checkIfUserLoggedIn();
    if (result == 'OK') {
      context
          .read<TodoService>()
          .getTodos(context.read<UserService>().currentUser!.email);
      context
          .read<TodoService>()
          .getItems(context.read<UserService>().currentUser!.email);
      context
          .read<TodoService>()
          .getNotes(context.read<UserService>().currentUser!.email);
      Navigator.popAndPushNamed(context, RouteManager.homePage);
    } else {
      Navigator.popAndPushNamed(context, RouteManager.loginPage);
    }
  }
}
