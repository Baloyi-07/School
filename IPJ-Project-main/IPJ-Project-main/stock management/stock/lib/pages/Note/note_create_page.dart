import 'package:flutter/material.dart';
import 'package:stock/widgets/note_form.dart';

class NoteCreatePage extends StatelessWidget {
  const NoteCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new Note'),
      ),
      body: Stack(
        children: const [
          Center(child: SingleChildScrollView(child: NoteForm())),
        ],
      ),
    );
  }
}
