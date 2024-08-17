
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/task.dart';

import '../provider/task_provider.dart';

class CreateTaskScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CreateTaskScreen();

}

class _CreateTaskScreen extends State<CreateTaskScreen>  with SingleTickerProviderStateMixin{


  late AnimationController controller;
  late Animation<double> scaleAnimation;
  final TextEditingController _priceController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final task_provider = Provider.of<TaskProvider>(context);
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
              'Enter Title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Title',
                errorText: _errorText,
                border: OutlineInputBorder(),
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
                    if (_validateAndSubmit()){
                      task_provider.addTask(Task(title: _priceController.text, isDone: 0, dateTime: DateFormat('dd-MMM-yyyy, hh:mm:a').format(DateTime.now()))),
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

  bool _validateAndSubmit() {
    String text = _priceController.text;

    if (text.isEmpty) {
      setState(() {
        _errorText = 'Enter Title';
      });
      return false;
    } else {
      return true;
    }
  }


}