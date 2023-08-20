import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/widgets/notes_items.dart';

import '../providers/notes.dart';

class NotesScreen extends StatefulWidget {
  static const routeName = '/notes-screen';
  bool isFavouriteScreen;
  NotesScreen({this.isFavouriteScreen = false});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  Future? _futureNotes;

  Future _getFutureNotes() {
    return Provider.of<Notes>(context, listen: false).fetchNotesInfo();
  }

  @override
  void initState() {
    _futureNotes = _getFutureNotes();
    super.initState();
  }

  Widget showMessage(String label) {
    return Center(
      child: Text(
        label,
        style: GoogleFonts.mavenPro(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    );
  }

  Center circularProgressIndicator = const Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Provider.of<Notes>(context, listen: false).fetchNotesInfo();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[100],
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  constraints: const BoxConstraints(maxHeight: 50),
                ),
                onChanged: (title) {
                  bool isEmpty = title.trim().isEmpty;
                  if (isEmpty) {
                    _getFutureNotes();
                  }
                  Provider.of<Notes>(context, listen: false).searchNotes(title);
                },
              ),
            ),
          ),
          FutureBuilder(
            future: _futureNotes,
            builder: (context, snapshot) {
              if (snapshot.error != null) {
                return showMessage('Something went wrong!');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return circularProgressIndicator;
              }
              return Consumer<Notes>(
                builder: (ctx, notesInfo, _) {
                  if (notesInfo.favNotes.isEmpty && widget.isFavouriteScreen) {
                    return showMessage('No Favourites added yet!');
                  }
                  if (notesInfo.notes.isEmpty && !widget.isFavouriteScreen) {
                    return showMessage('No notes added yet!');
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: widget.isFavouriteScreen
                          ? notesInfo.favNotes.length
                          : notesInfo.notes.length,
                      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                        value: widget.isFavouriteScreen
                            ? notesInfo.favNotes[index]
                            : notesInfo.notes[index],
                        child: NotesItems(),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
