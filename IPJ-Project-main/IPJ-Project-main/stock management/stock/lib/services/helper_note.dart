import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock/models/notes.dart';
import 'package:stock/models/todo.dart';
import 'package:stock/services/todo_service.dart';
import 'package:stock/services/user_service.dart';
import 'package:stock/widgets/dialogs.dart';

void refreshNotesInUI(BuildContext context) async {
  String result = await context.read<TodoService>().getNotes(
        context.read<UserService>().currentUser!.email,
      );
  if (result != 'OK') {
    showSnackBar(context, result);
  } else {
    showSnackBar(context, 'Data successfully retrieved from the database.');
  }
}

void saveAllNotesInUI(BuildContext context) async {
  String result = await context
      .read<TodoService>()
      .saveTodoEntry(context.read<UserService>().currentUser!.email, true);
  if (result != 'OK') {
    showSnackBar(context, result);
  } else {
    showSnackBar(context, 'Data successfully saved online!');
  }
}

void createNewNoteInUI(BuildContext context,
    {required TextEditingController titleController,required TextEditingController messageController}) async {
  if (titleController.text.isEmpty && messageController.text.isEmpty) {
    showSnackBar(context, 'Please enter a todo first, then save!');
  } else {
    Note note = Note(
      title: titleController.text.trim(),
      created: DateTime.now(), message: messageController.text.trim(),
    );
    if (context.read<TodoService>().notes.contains(note)) {
      showSnackBar(context, 'Duplicate value. Please try again.');
    } else {
      titleController.text = '';
      messageController.text = '';
      context.read<TodoService>().createNote(note);
      Navigator.pop(context);
    }
  }
}
