import 'package:flutter/material.dart';
import 'package:stock/pages/Item/Items.dart';
import 'package:stock/pages/Note/note_create_page.dart';
import 'package:stock/pages/Weather/home.dart';
import 'package:stock/pages/loading.dart';
import 'package:stock/pages/login.dart';
import 'package:stock/pages/register.dart';
import 'package:stock/pages/todo_page.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String homePage = '/homePage';
  static const String noteCreatePage = '/noteCreatePage';
  static const String registerPage = '/registerPage';
  static const String todoPage = '/todoPage';
  static const String loadingPage = '/loadingPage';
  static const String itemPage = '/itemPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => Login(),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (context) => Register(),
        );
      case homePage:
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );
      case itemPage:
        return MaterialPageRoute(
          builder: (context) => ItemPage(),
        );
      case todoPage:
        return MaterialPageRoute(
          builder: (context) => TodoPage(),
        );

      case noteCreatePage:
        return MaterialPageRoute(
          builder: (context) => NoteCreatePage(),
        );

      case loadingPage:
        return MaterialPageRoute(
          builder: (context) => Loading(),
        );

      default:
        throw FormatException('Route not found! Check routes again!');
    }
  }
}
