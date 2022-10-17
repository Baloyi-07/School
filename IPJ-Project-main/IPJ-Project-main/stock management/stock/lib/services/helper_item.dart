import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock/models/item.dart';
import 'package:stock/models/notes.dart';
import 'package:stock/models/todo.dart';
import 'package:stock/services/todo_service.dart';
import 'package:stock/services/user_service.dart';
import 'package:stock/widgets/dialogs.dart';

void refreshItemsInUI(BuildContext context) async {
  String result = await context.read<TodoService>().getNotes(
        context.read<UserService>().currentUser!.email,
      );
  if (result != 'OK') {
    showSnackBar(context, result);
  } else {
    showSnackBar(context, 'Data successfully retrieved from the database.');
  }
}

void saveAllItemsInUI(BuildContext context) async {
  String result = await context
      .read<TodoService>()
      .saveTodoEntry(context.read<UserService>().currentUser!.email, true);
  if (result != 'OK') {
    showSnackBar(context, result);
  } else {
    showSnackBar(context, 'Data successfully saved online!');
  }
}

void createNewItemInUI(BuildContext context,
    {required TextEditingController titleController,
    required TextEditingController itemController,
    required TextEditingController priceController}) async {
  if (titleController.text.isEmpty &&
      itemController.text.isEmpty &&
      priceController.text.isEmpty) {
    showSnackBar(context, 'Please enter a todo first, then save!');
  } else {
    Item item = Item(
      title: titleController.text.trim(),
      price: priceController.text.trim(),
      item: itemController.text.trim(),
      created: DateTime.now(),
    );
    if (context.read<TodoService>().notes.contains(item)) {
      showSnackBar(context, 'Duplicate value. Please try again.');
    } else {
      titleController.text = '';
      itemController.text = '';
      priceController.text = '';
      context.read<TodoService>().createItem(item);
      Navigator.pop(context);
    }
  }
}
