import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/material.dart';
import '/screens/notes_screen.dart';
import '/widgets/app_drawer.dart';
import 'text_to_speech_screen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});
  static const routeName = '/app-screen';
  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final _screens = [
    {
      'title': 'All Notes',
      'page': NotesScreen(),
    },
    {
      'title': 'Favourite Notes',
      'page': NotesScreen(isFavouriteScreen: true),
    },
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
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
          // widget.isFavouriteScreen ? 'Favourite Notes' : 'All Notes',
          _screens[_currentIndex]['title'] as String,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
      body: _screens[_currentIndex]['page'] as Widget,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () => setState(() {
                  _currentIndex = 0;
                }),
                iconSize: 30,
                color: Colors.grey,
                splashRadius: 25,
                icon: const Icon(FeatherIcons.fileText),
              ),
              IconButton(
                onPressed: () => setState(() {
                  _currentIndex = 1;
                }),
                iconSize: 30,
                color: Colors.red,
                splashRadius: 25,
                icon: const Icon(Icons.favorite),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: showFab
          ? FloatingActionButton(
              heroTag: null,
              elevation: 6,
              onPressed: () => Navigator.of(context).pushNamed(
                TextToSpeechScreen.routeName,
              ),
              backgroundColor: Colors.grey[200],
              child: const Icon(
                Icons.add,
                color: Colors.grey,
                size: 30,
              ),
            )
          : null,
    );
  }
}
