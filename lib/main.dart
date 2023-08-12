import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/screens/text_to_speech_screen.dart';
import '/screens/notes_screen.dart';
import '/providers/notes_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.bottom,
    ],
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Notes(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.grey,
          ),
          textTheme: TextTheme(
            titleLarge: GoogleFonts.mavenPro(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            titleMedium: GoogleFonts.mavenPro(
              color: Colors.black,
              fontSize: 16,
            ),
            titleSmall: GoogleFonts.mavenPro(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
        home: NotesScreen(),
        routes: {
          TextToSpeechScreen.routeName: (context) => TextToSpeechScreen(),
        },
      ),
    );
  }
}
