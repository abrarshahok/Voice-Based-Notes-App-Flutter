import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/notes_provider.dart';
import '/screens/text_to_speech_screen.dart';
import '/widgets/notes_items.dart';

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.grid_view_rounded, size: 40, color: Colors.black),
            const SizedBox(width: 20),
            Text('All Notes', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer<Notes>(
              builder: (ctx, notesInfo, _) => ListView.builder(
                itemCount: notesInfo.notes.length,
                itemBuilder: (ctx, index) => NotesItems(
                  id: notesInfo.notes[index].id,
                  title: notesInfo.notes[index].title,
                  description: notesInfo.notes[index].description,
                  dateTime: notesInfo.notes[index].dateTime,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        onPressed: () => Navigator.of(context).pushNamed(
          TextToSpeechScreen.routeName,
        ),
        backgroundColor: Colors.grey[200],
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
    );
  }
}
