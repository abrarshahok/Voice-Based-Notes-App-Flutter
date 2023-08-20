import 'package:google_fonts/google_fonts.dart';
import 'package:voice_based_notes_app/widgets/snackbar_widget.dart';
import '/screens/notes_info_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/providers/notes.dart';
import '/providers/auth.dart';

class NotesItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NotesInfo>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

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
          notes.title,
          style: GoogleFonts.mavenPro(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          DateFormat.MMMMd().format(notes.dateTime),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        trailing: Consumer<NotesInfo>(
          builder: (context, notes, _) => IconButton(
            onPressed: () => notes
                .toggleFavourites(
                  authToken: authData.token!,
                  userId: authData.userId!,
                )
                .then((_) => SnackBarWidget(
                      context: context,
                      label: notes.isFavourite
                          ? 'Note added to favorite'
                          : 'Note removed from favorites',
                      color: Colors.grey[200]!,
                    ).show()),
            icon: Icon(
              notes.isFavourite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Colors.redAccent,
          ),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: notes,
              child: const NotesInfoScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
