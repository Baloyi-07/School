import 'package:flutter/material.dart';
import 'package:stock/miscellaneous/constants.dart';
import 'package:stock/models/notes.dart';

class NoteViewPage extends StatelessWidget {
  const NoteViewPage({Key? key, required this.note}) : super(key: key);
  final Note note;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Note'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title :${note.title}',
                style: titleStyle,
              ),
              SizedBoxH20(),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Message : ${note.message}',
                  style: style14Blue,
                ),
              ),
            ],
          ),
        ));
  }
}
