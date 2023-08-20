import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/notes.dart';
import '../widgets/snackbar_widget.dart';
import 'text_to_speech_screen.dart';

class NotesInfoScreen extends StatelessWidget {
  const NotesInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    final notes = Provider.of<NotesInfo>(context, listen: false);

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
                      notes.title,
                      style: GoogleFonts.mavenPro(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat.MMMMEEEEd()
                          .addPattern('h:mm a')
                          .format(notes.dateTime),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            Expanded(
              flex: 8,
              child: ListView(
                children: [
                  Text(
                    notes.description,
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text('Do you want to delete note?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Provider.of<Notes>(context, listen: false)
                                  .deleteNote(notes.id)
                                  .then((value) => Navigator.of(context).pop())
                                  .whenComplete(() {
                                SnackBarWidget(
                                  context: context,
                                  label: 'Note deleted successfully.',
                                  color: Colors.grey[200]!,
                                ).show();
                                Navigator.of(context).pop();
                              });
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                iconSize: 30,
                splashRadius: 25,
                icon: const Icon(
                  FeatherIcons.trash2,
                  color: Colors.red,
                ),
              ),
              Consumer<NotesInfo>(
                builder: (context, notes, _) => IconButton(
                  onPressed: () => notes
                      .toggleFavourites(
                        userId: authData.userId!,
                        authToken: authData.token!,
                      )
                      .then((_) => SnackBarWidget(
                            context: context,
                            label: notes.isFavourite
                                ? 'Note added to favorite'
                                : 'Note removed from favorites',
                            color: Colors.grey[200]!,
                          ).show()),
                  iconSize: 30,
                  color: Colors.red,
                  splashRadius: 25,
                  icon: Icon(
                    notes.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_border_rounded,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(
            TextToSpeechScreen.routeName,
            arguments: {
              'id': notes.id,
              'title': notes.title,
              'description': notes.description,
              'isFavourite': notes.isFavourite,
            },
          );
        },
        backgroundColor: Colors.grey[200],
        elevation: 6,
        child: const Icon(
          FeatherIcons.edit,
          color: Colors.grey,
          size: 30,
        ),
      ),
    );
  }
}
