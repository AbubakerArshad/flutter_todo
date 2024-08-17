import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/notes.dart';
import 'package:todo_app/provider/notes_provider.dart';

class CreateNoteScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CreateNoteScreen();

}

class _CreateNoteScreen extends State<CreateNoteScreen> with SingleTickerProviderStateMixin{


  late AnimationController controller;
  late Animation<double> scaleAnimation;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final task_provider = Provider.of<NotesProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Title',
                errorText: _errorText,
                border: OutlineInputBorder(),
              ),
            ),Container(margin: EdgeInsets.only(top: 10),
              child: TextField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Description',
                  errorText: _descriptionErrorText,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog without returning a value
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: ()=> {
                    if (_validateAndSubmit() && _validateDescription()){
                      task_provider.addNotes(Notes(title: _titleController.text, description: _descriptionController.text, dateTime: DateFormat('dd-MMM-yyyy, hh:mm:a').format(DateTime.now()))),
                      Navigator.pop(context)
                    }
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _errorText;
  String? _descriptionErrorText;

  bool _validateAndSubmit() {
    String text = _titleController.text;

    if (text.isEmpty) {
      setState(() {
        _errorText = 'Enter Title';
      });
      return false;
    } else {
      return true;
    }
  }

  bool _validateDescription() {
    String text = _descriptionController.text;

    if (text.isEmpty) {
      setState(() {
        _descriptionErrorText = 'Enter Description';
      });
      return false;
    } else {
      return true;
    }
  }


}