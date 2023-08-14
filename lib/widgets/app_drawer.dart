import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/providers/auth.dart';
import '/screens/notes_screen.dart';
import '/screens/text_to_speech_screen.dart';

// ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});
  Divider divider = const Divider(color: Colors.white);

  final imageUrl =
      'https://img.freepik.com/free-photo/hand-holding-writing-checklist-application-form-document-clipboard-white-background-3d-illustration_56104-1551.jpg';

  Widget cutomListTile({
    required BuildContext ctx,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      tileColor: Colors.grey[200],
      leading: Icon(
        icon,
        color: Colors.grey,
        size: 30,
      ),
      title: Text(
        title,
        style: GoogleFonts.mavenPro(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.white,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          divider,
          cutomListTile(
            ctx: context,
            title: 'All Notes',
            icon: Icons.speaker_notes_rounded,
            onTap: () {
              Navigator.of(context).pushReplacementNamed(NotesScreen.routeName);
            },
          ),
          divider,
          cutomListTile(
            ctx: context,
            title: 'Add New Note',
            icon: Icons.note_add_rounded,
            onTap: () {
              Scaffold.of(context).closeDrawer();
              Navigator.of(context).pushNamed(TextToSpeechScreen.routeName);
            },
          ),
          divider,
          cutomListTile(
            ctx: context,
            title: 'Logout',
            icon: Icons.logout,
            onTap: () {
              Scaffold.of(context).closeDrawer();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
