import 'package:flutter/material.dart';
import 'package:v1/services/services.dart';

class Settings {
  // Function to show the popup dialog
  static void showPopup(BuildContext context) {
    // Define a text controller to manage the text field input
    TextEditingController _textController = TextEditingController();

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Customize border radius here
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Montant de vérification',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Montant en dollar',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Annuler'),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () async {
                        // Handle the save action
                        String enteredText = _textController.text;
                        print('Saved: $enteredText');
                        //TODO SAVE THE AMOUNT IN THE LOCAL DB
                        final databaseService = DatabaseService();
                        await databaseService.setAmount(double.parse(enteredText));

                        Navigator.of(context).pop(); // Close the dialog

                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      child: const Text('Enregistrer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
