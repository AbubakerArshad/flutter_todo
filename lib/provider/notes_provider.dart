import 'package:flutter/material.dart';

import '../main.dart';
import '../model/notes.dart';

class NotesProvider extends ChangeNotifier{

  List<Notes> _notes = [];

  List<Notes> get notes => _notes;

  Future<void> loadNotes() async {
    _notes= await dbHelper.getNotesList();
    notifyListeners();
  }

  void addNotes(Notes Notes) {
    Map<String, dynamic> row = {
      "title": Notes.title,
      "description": Notes.description,
      "dateTime": Notes.dateTime
    };
    dbHelper.createNote(row);
    notifyListeners();
  }

  void deleteNote(int note_id){
    dbHelper.deleteNote(note_id);
    notifyListeners();
  }

}