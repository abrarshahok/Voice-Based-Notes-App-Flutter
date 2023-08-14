import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class NotesInfo {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;

  NotesInfo({
    this.id = '',
    required this.title,
    required this.description,
    required this.dateTime,
  });
}

class Notes extends ChangeNotifier {
  List<NotesInfo> _notes = [];

  List<NotesInfo> get notes {
    return [..._notes];
  }

  Notes(this._authToken, this._userId, this._notes);
  final String _authToken;
  final String _userId;
  Future<void> fetchNotesInfo() async {
    final url =
        'https://notes-app-a8567-default-rtdb.firebaseio.com/notes.json?auth=$_authToken&orderBy="userId"&equalTo="$_userId"';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData == null) {
        return;
      }
      final Map<String, dynamic> notesInfo = responseData;
      final List<NotesInfo> loadedNotes = [];
      notesInfo.forEach((noteId, noteData) {
        loadedNotes.insert(
          0,
          NotesInfo(
            id: noteId,
            title: noteData['title'],
            description: noteData['description'],
            dateTime: DateTime.parse(noteData['dateTime']),
          ),
        );
      });
      _notes = loadedNotes;
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> saveNote(NotesInfo info) async {
    final url =
        'https://notes-app-a8567-default-rtdb.firebaseio.com/notes.json?auth=$_authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'userId': _userId,
            'title': info.title,
            'description': info.description,
            'dateTime': info.dateTime.toIso8601String(),
          },
        ),
      );
      final newNote = NotesInfo(
        id: json.decode(response.body)['name'],
        title: info.title,
        description: info.description,
        dateTime: info.dateTime,
      );
      _notes.insert(0, newNote);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateNote(String id, NotesInfo info) async {
    int currentIndex = _notes.indexWhere((note) => note.id == id);
    print(currentIndex);
    if (currentIndex >= 0) {
      final id = info.id;
      final url =
          'https://notes-app-a8567-default-rtdb.firebaseio.com/notes/$id.json?auth=$_authToken';

      try {
        await http.patch(
          Uri.parse(url),
          body: json.encode(
            {
              'title': info.title,
              'description': info.description,
              'dateTime': info.dateTime.toIso8601String(),
            },
          ),
        );
        _notes[currentIndex] = info;
        notifyListeners();
      } catch (_) {
        rethrow;
      }
    }
  }

  Future<void> deleteNote(String id) async {
    final url =
        'https://notes-app-a8567-default-rtdb.firebaseio.com/notes/$id.json?auth=$_authToken';
    int currentIndex = _notes.indexWhere((note) => note.id == id);
    final noteToBeDeleted = _notes[currentIndex];
    _notes.removeAt(currentIndex);
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _notes.insert(currentIndex, noteToBeDeleted);
      notifyListeners();
      throw const HttpException('Unable to delete note from server');
    }
    notifyListeners();
  }
}
