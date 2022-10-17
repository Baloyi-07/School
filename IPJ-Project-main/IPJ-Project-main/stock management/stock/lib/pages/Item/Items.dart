import 'dart:io';

import 'package:backendless_sdk/backendless_sdk.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart' as provider;
import 'package:stock/routes/routes.dart';
import 'package:stock/services/helper_item.dart';
import 'package:stock/services/helper_todo.dart';
import 'package:stock/services/helper_user.dart';
import 'package:stock/services/todo_service.dart';
import 'package:stock/services/user_service.dart';
import 'package:stock/widgets/app_progress_indicator.dart';
import 'package:stock/widgets/items_card.dart';
import 'package:stock/widgets/todo_card.dart';
import 'package:tuple/tuple.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  File? image;
  late TextEditingController todoController;
  late TextEditingController priceController;
  late TextEditingController itemController;

  Future<void> pickImage(ImageSource source) async {
    // print(await ImagePicker().pickImage(source: ImageSource.gallery));
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final ImageTemp = File(image.path);
      setState(() {
        this.image = ImageTemp;
        print(ImageTemp);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: ${e}');
    }
  }

  @override
  void initState() {
    super.initState();
    todoController = TextEditingController();
    priceController = TextEditingController();
    itemController = TextEditingController();
  }

  @override
  void dispose() {
    todoController.dispose();
    priceController.dispose();
    itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.pink,
              size: 30,
            ),
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text('Create  new Items'),
                    content: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              hintText: 'Please enter Categories name'),
                          controller: todoController,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              hintText: 'Please enter Item name'),
                          controller: itemController,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              hintText: 'Please enter Item Price'),
                          controller: priceController,
                        ),
                        Column(
                          children: [
                            image != null
                                ? ClipOval(
                                    child: Image.file(
                                      image!,
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : FlutterLogo(
                                    size: 160,
                                  ),
                            buildButton(
                                title: 'Pick Gallery',
                                icon: Icons.camera_alt_outlined,
                                onClicked: () {
                                  pickImage(ImageSource.gallery);
                                }),
                            buildButton(
                                title: 'Pick Camera',
                                icon: Icons.camera_alt_outlined,
                                onClicked: () {
                                  pickImage(ImageSource.camera);
                                }),
                          ],
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('Save'),
                        onPressed: () async {
                          createNewItemInUI(
                            context,
                            titleController: todoController,
                            itemController: itemController,
                            priceController: priceController,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () {
              // Navigator.of(context).pushNamed(RouteManager.todoPage);
            },
            child: Text(
              'Add Items',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.save,
          //     color: Colors.white,
          //     size: 30,
          //   ),
          //   onPressed: () async {
          //     saveAllTodosInUI(context);
          //   },
          // ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              refreshTodosInUI(context);
            },
          ),
        ],
        title: Text('Caterogies And Items'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink, Colors.blue],
          ),
        ),
        child: Stack(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: provider.Selector<UserService, BackendlessUser?>(
                      selector: (context, value) => value.currentUser,
                      builder: (context, value, child) {
                        return value == null
                            ? Container()
                            : Text(
                                '${value.getProperty('name')}\'s Caterogies list',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 46,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white,
                                ),
                              );
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 20),
                      child: provider.Consumer<TodoService>(
                        builder: (context, value, child) {
                          return ListView.builder(
                            itemCount: value.items.length,
                            itemBuilder: (context, index) {
                              return ItemCard(
                                item: value.items[index],
                                itemToggleAction: (valueStatus) async {
                                  context
                                      .read<TodoService>()
                                      .toggleItemDone(index);
                                },
                                deleteAction: () async {
                                  context
                                      .read<TodoService>()
                                      .deleteItem(value.items[index]);
                                },
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
      ),
    );
  }
}

Widget buildButton({
  required String title,
  required IconData icon,
  required VoidCallback onClicked,
}) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(56),
          primary: Colors.white,
          onPrimary: Colors.black,
          textStyle: TextStyle(fontSize: 15)),
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
          ),
          SizedBox(
            width: 16,
          ),
          Text(title)
        ],
      ),
      onPressed: onClicked,
    );
