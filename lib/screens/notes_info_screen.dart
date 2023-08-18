import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/notes.dart';
import 'text_to_speech_screen.dart';

class NotesInfoScreen extends StatelessWidget {
  static const routeName = '/notes-info-screen';
  Widget gap(double n) {
    return SizedBox(height: n);
  }

  @override
  Widget build(BuildContext context) {
    final notesData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final id = notesData['id'];
    final title = notesData['title'];
    final description = notesData['description'];
    final dateTime = notesData['dateTime'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.mavenPro(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    gap(5),
                    Text(
                      DateFormat.MMMMEEEEd()
                          .addPattern('h:mm a')
                          .format(dateTime),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            gap(10),
            Expanded(
              flex: 8,
              child: ListView(
                children: [
                  Text(
                    description,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              splashRadius: 5,
              onPressed: () {
                Provider.of<Notes>(context, listen: false).deleteNote(id);
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              splashRadius: 5,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  TextToSpeechScreen.routeName,
                  arguments: {
                    'id': id,
                    'title': title,
                    'description': description,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
