import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../notes_bloc/notes_bloc.dart';
import '../../models/notes/notes.dart';
import '/utils/utils.dart';

class NewNotesScreen extends StatelessWidget {
  const NewNotesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    String date = DateFormat.yMMMEd().format(DateTime.now()).toString();
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: PopScope(
          onPopInvokedWithResult: (didPop, result) {
            //simple if condition to check if either one of
            ////the field is not empty then save the note
            if (titleController.text.isNotEmpty ||
                contentController.text.isNotEmpty) {
              final notes = Notes(
                title: titleController.text,
                date: date.toString(),
                content: contentController.text,
              );
              context.read<NotesBloc>().add(AddNotesEvent(notes: notes));
            }
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              forceMaterialTransparency: true,
              surfaceTintColor: Theme.of(context).appBarTheme.surfaceTintColor,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              actions: [
                //TODO: fix bookmark
                IconButton(
                    tooltip: 'Add Bookmark',
                    onPressed: () {
                      context.read<NotesBloc>().add(
                          UpdateBookMarkEvent(isBookMarked: true, index: 0));
                    },
                    icon: Icon(Icons.bookmark_outline_rounded)),

                //TODO: Add an explicit save button to save the notes on demand
                IconButton(
                    tooltip: 'Save note',
                    onPressed: () {
                      if (titleController.text.isNotEmpty ||
                          contentController.text.isNotEmpty) {
                        final notes = Notes(
                          title: titleController.text,
                          date: date.toString(),
                          content: contentController.text,
                        );
                        context
                            .read<NotesBloc>()
                            .add(AddNotesEvent(notes: notes));
                      }
                    },
                    icon: Icon(Icons.check_rounded)),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    minLines: 1,
                    maxLines: 3,
                    controller: titleController,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontSize: 30),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      hintText: 'Title 👀',
                      hintStyle: TextStyle(
                        fontSize: 30,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      date,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  TextField(
                    minLines: 1,
                    maxLines: 1000,
                    controller: contentController,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontSize: 20),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      hintMaxLines: 100,
                      hintText: hintText,
                      hintStyle: TextStyle(fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}