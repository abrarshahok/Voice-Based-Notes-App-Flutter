import 'package:flutter/foundation.dart';

class NotesInfo {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;

  NotesInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
  });
}

class Notes extends ChangeNotifier {
  final List<NotesInfo> _notes = [
    NotesInfo(
      id: DateTime.now().toString(),
      title: 'Programming Session',
      description: 'Engaging in a coding session scheduled for midnight.',
      dateTime: DateTime.now(),
    ),
    NotesInfo(
      id: DateTime.now().toString(),
      title: 'Exploring New Places',
      description:
          'Planning an upcoming excursion to an unfamiliar destination.',
      dateTime: DateTime.now(),
    ),
    NotesInfo(
      id: DateTime.now().toString(),
      title: 'Gaming Time',
      description: 'Set to indulge in gaming adventures at 10 PM.',
      dateTime: DateTime.now(),
    ),
  ];
  List<NotesInfo> get notes {
    return [..._notes];
  }

  void saveNote(NotesInfo info) {
    _notes.add(info);
    notifyListeners();
  }

  void updateNote(NotesInfo info) {
    int currentIndex = _notes.indexWhere((note) => note.id == info.id);
    _notes[currentIndex] = info;
    notifyListeners();
  }
}
