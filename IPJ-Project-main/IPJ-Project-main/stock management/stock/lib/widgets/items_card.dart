import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stock/models/item.dart';
import 'package:stock/models/notes.dart';
import 'package:stock/models/todo.dart';
import 'package:stock/services/helper_item.dart';
import 'package:stock/services/todo_service.dart';
import 'package:provider/provider.dart' as provider;
import 'package:stock/widgets/todo_card.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    Key? key,
    required this.item,
    required this.deleteAction,
    required this.itemToggleAction,
  }) : super(key: key);
  final Item item;
  final Function() deleteAction;
  final Function(bool? value) itemToggleAction;

  @override
  State<ItemCard> createState() =>
      _ItemCardState(item, deleteAction, itemToggleAction);
}

class _ItemCardState extends State<ItemCard> {
  Item item;
  Function() deleteAction;
  Function(bool? value) itemToggleAction;
  _ItemCardState(this.item, this.deleteAction, this.itemToggleAction);
  File? image;
  late TextEditingController todoController;
  late TextEditingController priceController;
  late TextEditingController itemController;

  late String temptodo = todoController.text;
  late String tempprice = priceController.text;
  late String tempItem = itemController.text;

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
    return Card(
      color: Colors.purple.shade300,
      child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              caption: 'Delete',
              color: Colors.purple[600],
              icon: Icons.delete,
              onTap: deleteAction,
            ),
          ],
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Picture'),
                  Column(
                    children: [
                      Text(
                        'Caterogory name: ${item.title}',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Items name:',
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Price:',
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
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
                                      hintText: '${item.title}'),
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
                                onPressed: () {
                                  if (temptodo != todoController ||
                                      tempprice != priceController.text ||
                                      tempItem != itemController.text) {
                                    deleteAction;
                                  }

                                  createNewItemInUI(context,
                                      titleController: todoController,
                                      itemController: itemController,
                                      priceController: priceController);

                                  //   if (temptodo != todoController ||
                                  //       tempprice != priceController.text ||
                                  //       tempItem != itemController.text) {

                                  //         deleteAction: () async {
                                  //   context
                                  //       .read<TodoService>()
                                  //       .deleteTodo(value.todos[index]);
                                  // },
                                  //       }
                                  // Navigator.pop(context);
                                  // setState(() {
                                  //   item.title = todoController.text;
                                  // });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Edit'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      child: Text('Update Sold Item'),
                      onPressed: () {},
                    ),
                  )
                ],
              )
            ],
          )

          //  CheckboxListTile(
          //   checkColor: Colors.purple,
          //   activeColor: Colors.purple[100],
          //   value: todo.done,
          //   onChanged: todoToggleAction,
          //   subtitle: Text(
          //     '${todo.created.day}/${todo.created.month}/${todo.created.year}',
          //     style: TextStyle(color: Colors.white, fontSize: 10),
          //   ),
          //   title: Text(
          //     todo.title,
          //     style: TextStyle(
          //       color: Colors.white,
          //       decoration:
          //           todo.done ? TextDecoration.lineThrough : TextDecoration.none,
          //     ),
          //   ),
          // ),
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


// class ItemCard extends StatelessWidget {
//   const ItemCard({
//     Key? key,
//     required this.item,
//     required this.deleteAction,
//     required this.itemToggleAction,
//   }) : super(key: key);
//   final Item item;
//   final Function() deleteAction;
//   final Function(bool? value) itemToggleAction;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.purple.shade300,
//       child: Slidable(
//           actionPane: SlidableDrawerActionPane(),
//           secondaryActions: [
//             IconSlideAction(
//               caption: 'Delete',
//               color: Colors.purple[600],
//               icon: Icons.delete,
//               onTap: deleteAction,
//             ),
//           ],
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text('Picture'),
//                   Column(
//                     children: [
//                       Text(
//                         'Caterogory name: ${item.title}',
//                         style: TextStyle(fontSize: 15, color: Colors.white),
//                       ),
//                       SizedBox(
//                         height: 4,
//                       ),
//                       Text('Items name:',
//                           style: TextStyle(fontSize: 15, color: Colors.white)),
//                       SizedBox(
//                         height: 4,
//                       ),
//                       Text('Price:',
//                           style: TextStyle(fontSize: 15, color: Colors.white)),
//                       SizedBox(
//                         height: 4,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: Text('Edit'),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8.0),
//                     child: ElevatedButton(
//                       child: Text('Update Sold Item'),
//                       onPressed: () {},
//                     ),
//                   )
//                 ],
//               )
//             ],
//           )

//           //  CheckboxListTile(
//           //   checkColor: Colors.purple,
//           //   activeColor: Colors.purple[100],
//           //   value: todo.done,
//           //   onChanged: todoToggleAction,
//           //   subtitle: Text(
//           //     '${todo.created.day}/${todo.created.month}/${todo.created.year}',
//           //     style: TextStyle(color: Colors.white, fontSize: 10),
//           //   ),
//           //   title: Text(
//           //     todo.title,
//           //     style: TextStyle(
//           //       color: Colors.white,
//           //       decoration:
//           //           todo.done ? TextDecoration.lineThrough : TextDecoration.none,
//           //     ),
//           //   ),
//           // ),
//           ),
//     );
//   }
// }
