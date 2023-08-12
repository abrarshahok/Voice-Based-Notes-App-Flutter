import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/providers/notes_provider.dart';
import '/screens/text_to_speech_screen.dart';
import '/widgets/notes_items.dart';

class NotesScreen extends StatefulWidget {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.grid_view_rounded,
              size: 40,
              color: Colors.black,
            ),
            const SizedBox(width: 20),
            Text('All Notes', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Provider.of<Notes>(context, listen: false).fetchNotesInfo();
        },
        child: FutureBuilder(
          future: _futureNotes,
          builder: (context, snapshot) {
            if (snapshot.error != null) {
              return showMessage('Something went wrong!');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return circularProgressIndicator;
            }
            return Consumer<Notes>(
              builder: (ctx, notesInfo, _) {
                if (notesInfo.notes.isEmpty) {
                  return showMessage('No notes added yet!');
                }
                return ListView.builder(
                  itemCount: notesInfo.notes.length,
                  itemBuilder: (ctx, index) => NotesItems(
                    id: notesInfo.notes[index].id,
                    title: notesInfo.notes[index].title,
                    description: notesInfo.notes[index].description,
                    dateTime: notesInfo.notes[index].dateTime,
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        onPressed: () => Navigator.of(context).pushNamed(
          TextToSpeechScreen.routeName,
        ),
        backgroundColor: Colors.grey[200],
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }
}
