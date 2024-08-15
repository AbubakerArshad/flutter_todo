import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              'Enter Price',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Task Title',
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
                  onPressed: _validateAndSubmit,
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

  void _validateAndSubmit() {
    String text = _priceController.text;

    if (text.isEmpty) {
      setState(() {
        _errorText = 'Enter Title';
      });
    } else {
      var price = int.parse(text);
      // _updatePackagePrice(price , initPkPackageId ?? -1);
      // Navigator.pop(context, text); // Return the valid price
    }
  }


}