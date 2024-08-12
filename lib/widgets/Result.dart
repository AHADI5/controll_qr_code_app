import 'package:flutter/material.dart';
import 'package:v1/widgets/Home.dart'; // Import the Home widget for rescanning

class VerificationResultPage extends StatelessWidget {
  final bool isInOrder;

  const VerificationResultPage({super.key, required this.isInOrder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Result'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isInOrder ? Icons.check_circle : Icons.error,
              color: isInOrder ? Colors.green : Colors.red,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              isInOrder ? "En ordre!" : "Pas en ordre",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isInOrder ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Rescan"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
