import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:voice_based_notes_app/providers/notes.dart';
import '/screens/text_to_speech_screen.dart';
import 'package:intl/intl.dart';

class NotesItems extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;

  const NotesItems({super.key, 
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  Widget gap(double n) {
    return SizedBox(height: n);
  }

  void _showInfo(BuildContext context) {
    showModalBottomSheet(
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Column(
                    children: [
                      Text('Edit',
                          style: Theme.of(context).textTheme.titleSmall),
                      IconButton(
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
                        icon: const Icon(Icons.edit_note_rounded),
                        iconSize: 30,
                      ),
                    ],
                  )
                ],
              ),
              const Divider(),
              gap(10),
              Text(
                description,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.grey[200],
        title: Text(
          title,
          style: GoogleFonts.mavenPro(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          DateFormat.MMMMd().format(dateTime),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        trailing: IconButton(
          onPressed: () {
            Provider.of<Notes>(context, listen: false).deleteNote(id);
          },
          icon: const Icon(Icons.delete),
          color: Colors.redAccent,
        ),
        onTap: () => _showInfo(context),
      ),
    );
  }
}
