import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/screens/text_to_speech_screen.dart';
import 'package:provider/provider.dart';
import '/widgets/notes_items.dart';
import '/widgets/app_drawer.dart';
import '../providers/notes.dart';

class NotesScreen extends StatefulWidget {
  static const routeName = '/notes-screen';

  const NotesScreen({super.key});
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
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(
              Icons.grid_view_rounded,
              size: 40,
              color: Colors.black,
            ),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'All Notes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
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
                    Provider.of<Notes>(context, listen: false)
                        .searchNotes(title);
                  },
                ),
              ),
            ),
            FutureBuilder(
              future: _futureNotes,
              builder: (context, snapshot) {
                if (snapshot.error != null) {
                  return showMessage('Something went wrong!');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return circularProgressIndicator;
                }
                return Consumer<Notes>(
                  builder: (ctx, notesInfo, _) {
                    if (notesInfo.notes.isEmpty) {
                      return showMessage('No notes added yet!');
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: notesInfo.notes.length,
                        itemBuilder: (ctx, index) =>
                            ChangeNotifierProvider.value(
                          value: notesInfo.notes[index],
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
