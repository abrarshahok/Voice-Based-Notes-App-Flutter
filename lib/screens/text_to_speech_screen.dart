import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '/providers/notes_provider.dart';

class TextToSpeechScreen extends StatefulWidget {
  static const routeName = '/text-to-speech-screen';
  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _enableTyping = false;

  void _startListening() async {
    if (!_speechEnabled) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _speechEnabled = true;
          _speechToText.listen(
            cancelOnError: true,
            onResult: (result) {
              setState(() {
                _descriptionController.text = result.recognizedWords;
              });
            },
          );
        });
      }
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _speechEnabled = false;
    });
  }

  final OutlineInputBorder _border = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(15),
    ),
  );

  Widget customText({
    required String label,
    required Color color,
    required double size,
  }) {
    return Text(
      label,
      style: GoogleFonts.mavenPro(
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: size,
      ),
    );
  }

  Widget gap(double n) {
    return SizedBox(height: n);
  }

  Widget customContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200],
      ),
      child: child,
    );
  }

  bool _didChange = true;
  String _id = '';
  @override
  void didChangeDependencies() {
    if (_didChange) {
      final info = ModalRoute.of(context)?.settings.arguments;
      if (info != null) {
        final infoMap = info as Map<String, String>;
        _id = infoMap['id'] as String;
        _titleController.text = infoMap['title'] as String;
        _descriptionController.text = infoMap['description'] as String;
      }
      _didChange = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add Note', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              final notesInfo = NotesInfo(
                id: _id.isEmpty ? DateTime.now().toString() : _id,
                title: _titleController.text,
                description: _descriptionController.text,
                dateTime: DateTime.now(),
              );
              if (_id.isNotEmpty) {
                Provider.of<Notes>(context, listen: false).updateNote(
                  notesInfo,
                );
              } else {
                Provider.of<Notes>(context, listen: false).saveNote(
                  notesInfo,
                );
              }
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.save),
            iconSize: 30,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  label: 'Title',
                  color: Colors.black,
                  size: 20,
                ),
                gap(20),
                customContainer(
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Add a new title',
                      focusColor: Colors.white,
                      border: _border,
                      focusedBorder: _border,
                      enabledBorder: _border,
                    ),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  ),
                ),
                gap(50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      label: 'Description',
                      color: Colors.black,
                      size: 20,
                    ),
                    Column(
                      children: [
                        Switch(
                          value: _enableTyping,
                          onChanged: (value) {
                            setState(() {
                              _enableTyping = value;
                            });
                          },
                        ),
                        customText(
                          label: 'Enable Typing',
                          color: Colors.grey,
                          size: 15,
                        ),
                      ],
                    )
                  ],
                ),
                gap(20),
                customContainer(
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Add Description by (voice/type)',
                      focusColor: Colors.white,
                      border: _border,
                      focusedBorder: _border,
                      enabledBorder: _border,
                    ),
                    maxLines: 10,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    readOnly: !_enableTyping,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !_enableTyping
          ? AvatarGlow(
              endRadius: 75.0,
              animate: _speechEnabled,
              glowColor: Colors.grey,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              repeatPauseDuration: const Duration(milliseconds: 100),
              child: GestureDetector(
                onTapDown: (_) => _startListening(),
                onTapUp: (_) => _stopListening(),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    _speechEnabled ? Icons.mic : Icons.mic_none,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
