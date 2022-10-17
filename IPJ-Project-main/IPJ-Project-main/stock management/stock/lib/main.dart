import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock/lifecycle.dart';
import 'package:stock/pages/Note/note_view_model.dart';
import 'package:stock/routes/routes.dart';
import 'package:stock/services/todo_service.dart';
import 'package:stock/services/user_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NoteViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserService(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoService(),
        )
      ],
      child: LifeCycle(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: RouteManager.loadingPage,
          onGenerateRoute: RouteManager.generateRoute,
        ),
      ),
    );
  }
}
