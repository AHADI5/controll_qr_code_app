import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/services.dart';

class Settings {
  // Function to show the popup dialog
  static Future<void> showPopup(
      BuildContext context, Function(double) onAmountSaved) async {
    TextEditingController _textController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
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
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Annuler'),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () async {
                        String enteredText = _textController.text;
                        final databaseService = DatabaseService();
                        double newAmount = double.parse(enteredText);
                        await databaseService.setAmount(newAmount);

                        onAmountSaved(newAmount);

                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                        foregroundColor:
                        MaterialStateProperty.all(Colors.white),
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
