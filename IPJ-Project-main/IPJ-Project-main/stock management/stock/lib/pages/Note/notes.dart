import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:stock/models/notes.dart';
import 'package:stock/pages/Note/note_create_page.dart';
import 'package:stock/pages/Note/note_view_page.dart';
import 'package:stock/routes/routes.dart';
import 'package:stock/services/locator_service.dart';
import 'package:stock/services/navigation_and_dialog_service.dart';
import 'package:stock/services/todo_service.dart';
import 'package:provider/provider.dart' as provider;
import 'package:stock/services/user_service.dart';
import 'package:stock/widgets/app_progress_indicator.dart';
import 'package:tuple/tuple.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Notes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.lock),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NoteCreatePage(),
                ),
              );
              locator
                  .get<NavigationAndDialogService>()
                  .navigateTo(RouteManager.noteCreatePage);
            },
            icon: const Icon(Icons.add),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.exit_to_app,
                      //     color: Colors.white,
                      //     size: 30,
                      //   ),
                      //   onPressed: () {
                      //     logoutUserInUI(context);
                      //   },
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20),
                    child: provider.Consumer<TodoService>(
                      builder: (context, value, child) {
                        return ListView.builder(
                          itemCount: value.notes.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.blueGrey,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NoteViewPage(
                                                note: value.notes[index],
                                              )));
                                },
                                title: Text(value.notes[index].title),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          provider.Selector<UserService, Tuple2>(
            selector: (context, value) =>
                Tuple2(value.showUserProgress, value.userProgressText),
            builder: (context, value, child) {
              return value.item1
                  ? AppProgressIndicator(text: value.item2)
                  : Container();
            },
          ),
          provider.Selector<TodoService, Tuple2>(
            selector: (context, value) =>
                Tuple2(value.busyRetrieving, value.busySaving),
            builder: (context, value, child) {
              return value.item1
                  ? AppProgressIndicator(
                      text:
                          'Busy retrieving data from the database...please wait...')
                  : value.item2
                      ? AppProgressIndicator(
                          text:
                              'Busy saving data to the database...please wait...')
                      : Container();
            },
          ),
        ],
      ),
    );
  }
}
//

//
