import 'package:google_fonts/google_fonts.dart';
import '/screens/notes_info_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/providers/notes.dart';
import '/providers/auth.dart';

class NotesItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<NotesInfo>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    void showInfo(BuildContext context) {
      Navigator.of(context).pushNamed(
        NotesInfoScreen.routeName,
        arguments: {
          'id': product.id,
          'title': product.title,
          'description': product.description,
          'dateTime': product.dateTime,
        },
      );
    }

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
          product.title,
          style: GoogleFonts.mavenPro(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          DateFormat.MMMMd().format(product.dateTime),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        trailing: Consumer<NotesInfo>(
          builder: (context, product, _) => IconButton(
            onPressed: () {
              product.toggleFavourites(
                authToken: authData.token!,
                userId: authData.userId!,
              );
            },
            icon: Icon(
              product.isFavourite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Colors.redAccent,
          ),
        ),
        onTap: () => showInfo(context),
      ),
    );
  }
}
