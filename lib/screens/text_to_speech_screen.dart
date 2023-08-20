import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../providers/notes.dart';
import '../widgets/snackbar_widget.dart';

class TextToSpeechScreen extends StatefulWidget {
  static const routeName = '/text-to-speech-screen';

  const TextToSpeechScreen({super.key});
  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _enableTyping = false;
  bool _didChange = true;
  bool _isLoading = false;
  bool _isFavourite = false;
  String _id = '';

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
    borderSide: BorderSide(color: Colors.black),
    borderRadius: BorderRadius.all(Radius.circular(15)),
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

  Widget customContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200],
      ),
      child: child,
    );
  }

  @override
  void didChangeDependencies() {
    if (_didChange) {
      final info = ModalRoute.of(context)?.settings.arguments;
      if (info != null) {
        final infoMap = info as Map<String, dynamic>;
        _id = infoMap['id'] as String;
        _titleController.text = infoMap['title'] as String;
        _descriptionController.text = infoMap['description'] as String;
        _isFavourite = infoMap['isFavourite'] as bool;
      }
      _didChange = false;
    }
    super.didChangeDependencies();
  }

  void showDialogMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('An error Occured!'),
          content: const Text('Something went wrong!'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Okay!'),
            )
          ],
        );
      },
    );
  }

  void _saveAndClose() {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      return;
    }

    if (!mounted) {
      return; // Check if the widget is still mounted before continuing
    }

    setState(() {
      _isLoading = true;
    });

    final notesInfo = NotesInfo(
      title: _titleController.text,
      description: _descriptionController.text,
      dateTime: DateTime.now(),
      isFavourite: _isFavourite,
    );

    final notesProvider = Provider.of<Notes>(context, listen: false);

    final saveOrUpdateFuture = _id.isNotEmpty
        ? notesProvider.updateNote(_id, notesInfo)
        : notesProvider.saveNote(notesInfo);

    saveOrUpdateFuture.catchError((_) => showDialogMessage()).then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      SnackBarWidget(
        context: context,
        label: 'Note ${_id.isNotEmpty ? "updated" : "added"} successfully',
        color: Colors.grey[200]!,
      ).show();
      Navigator.of(context).pop();
    });
  }

  // @override
  // void dispose() {
  //   _titleController.dispose();
  //   _descriptionController.dispose();
  //   _speechToText.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final bool isFocus = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add Note', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _saveAndClose,
            icon: const Icon(Icons.save),
            iconSize: 30,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 50),
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
                      const SizedBox(height: 20),
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
      floatingActionButton: (isFocus && !_enableTyping)
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
          : null,
    );
  }
}
