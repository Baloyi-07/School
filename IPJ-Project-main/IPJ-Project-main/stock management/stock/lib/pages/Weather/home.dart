import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stock/pages/Note/notes.dart';
import 'package:stock/pages/Weather/weather.dart';
import 'package:stock/pages/todo_page.dart';
import 'package:stock/routes/routes.dart';
import 'package:stock/services/helper_user.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                //  _getCurrentLocation();
              },
              child: Icon(Icons.location_city, size: 36.0),
            ),
          )
        ],
        title: Padding(
          padding: const EdgeInsets.only(left: 100.0),
          child: const Text('Home'),
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: const NavigationDrawer(),
      body: WeatherPage(),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        child: Container(
          decoration: BoxDecoration(
              // color: Colors.purple,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topLeft,
                colors: [Colors.purple, Colors.blue],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(80),
                topLeft: Radius.circular(80),
              )),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.home, size: 40.0),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteManager.todoPage);
                },
                child: Text(
                  'Manage Your Invertory',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue,
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[buildHeader(context), buildMenuItems(context)],
        ),
      ),
    );
  }
}

Widget buildHeader(BuildContext context) => Container(
      color: Colors.blue.shade700,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundImage: NetworkImage(
                "https://static.remove.bg/remove-bg-web/bf2ec228bc55da2aaa8a6978c6fe13e205c3849c/assets/start_remove-c851bdf8d3127a24e2d137a55b1b427378cd17385b01aec6e59d5d4b5f39d2ec.png"),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Name',
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
          Text(
            'Email',
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
        ],
      ),
    );

Widget buildMenuItems(BuildContext context) => Container(
      //color: Colors.grey,
      padding: EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 12,
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Home"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.notes_outlined),
            title: const Text("Notes"),
            onTap: () {
              //Navigator.pop(context);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NoteListPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate_outlined),
            title: const Text("Calculator"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.forest_outlined),
            title: const Text("Market Forecast"),
            onTap: () {},
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(Icons.settings_accessibility_outlined),
            title: const Text("Settings"),
            onTap: () {},
          ),
          Divider(
            color: Colors.black,
          ),
          Container(
            color: Colors.red.shade200,
            child: ListTile(
              leading: const Icon(Icons.offline_bolt_outlined),
              title: const Text("Sign Out"),
              onTap: () {
                logoutUserInUI(context);
              },
            ),
          ),
        ],
      ),
    );
