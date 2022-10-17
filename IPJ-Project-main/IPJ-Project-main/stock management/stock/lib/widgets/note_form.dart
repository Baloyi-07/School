import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock/pages/Note/note_view_model.dart';
import 'package:stock/services/helper_note.dart';

import '../miscellaneous/constants.dart';
import '../miscellaneous/validators.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({
    Key? key,
  }) : super(key: key);

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late TextEditingController titleController;
  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<NoteViewModel>().noteFormKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'New Note',
              style: headingStyle,
            ),
            const SizedBoxH30(),
            TextFormField(
              validator: validateEmptyTitle,
              controller: titleController,
              decoration: formDecoration('Title', Icons.book),
            ),
            const SizedBoxH10(),
            TextFormField(
              maxLines: 6,
              minLines: 3,
              validator: validateEmptyMessage,
              controller: messageController,
              decoration: formDecoration('Content', Icons.message),
            ),
            const SizedBoxH20(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              onPressed: () {
                createNewNoteInUI(context, titleController: titleController, messageController: messageController);
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
