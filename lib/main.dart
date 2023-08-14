import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/providers/auth.dart';
import '/screens/auth_screen.dart';
import '/screens/text_to_speech_screen.dart';
import '/screens/notes_screen.dart';
import 'providers/notes.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Notes>(
          update: (ctx, authData, previousNotes) => Notes(
            authData.token != null ? authData.token! : '',
            authData.userId != null ? authData.userId! : '',
            previousNotes!.notes,
          ),
          create: (ctx) => Notes('', '', []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
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
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          home: authData.isAuth ? const NotesScreen() : const AuthScreen(),
          routes: {
            TextToSpeechScreen.routeName: (context) => const TextToSpeechScreen(),
            NotesScreen.routeName: (context) => const NotesScreen(),
          },
        ),
      ),
    );
  }
}
