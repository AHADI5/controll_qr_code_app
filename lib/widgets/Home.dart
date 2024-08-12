import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:v1/widgets/Settings.dart';
import 'package:v1/widgets/qr_code_scanner.dart'; // Ensure this path is correct
import 'package:v1/services/synchronisation.dart';
import 'package:v1/widgets/Result.dart';

import 'Verification.dart'; // Import the Verification service

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isScanning = false; // State to determine if the scanner is visible
  bool _isSynchronizing = false; // State to manage synchronization progress
  String _syncStatusMessage = ''; // Message to show synchronization status
  bool _isVerifying = false; // State to manage verification progress

  // Function to handle the scan result and display it in a new page
  void _handleScanResult(String? result) async {
    if (result != null) {
      print("the result is  .... $result") ;



      try {
        // Assuming the result is the student ID
        final int studentID = int.parse(result); // Convert scanned result to studentID
        final Verification verification = Verification();
        final bool isInOrder = await verification.checkStudent(studentID);

        // Navigate to the result page
        Navigator.of(context).pushNamed(
          "/verificationResult",
          arguments: isInOrder,
        );
      } catch (e) {
        // Handle errors, e.g., invalid studentID format
        print('Error during verification: $e');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const VerificationResultPage(isInOrder: false),
          ),
        );
      }
    }
  }

  // Function to start synchronization
  Future<void> _startSynchronization() async {
    setState(() {
      _isSynchronizing = true; // Show progress indicator
      _syncStatusMessage = 'Synchronizing...'; // Set status message
    });

    try {
      SyncService syncService = SyncService();
      await syncService.synchronizeWithServer('http://10.0.2.2:8080/api/v1/students/');

      // Update the state after synchronization is complete
      setState(() {
        _isSynchronizing = false;
        _syncStatusMessage = 'Synchronized'; // Update status message
      });
    } catch (e) {
      // Handle any errors that occur during synchronization
      setState(() {
        _isSynchronizing = false;
        _syncStatusMessage = 'Synchronization failed'; // Error message
      });
      print('Error during synchronization: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              if (_isVerifying) ...[
                const Text('Verification in progress...'), // Loader message
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
              ],
              Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                margin: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.5,
                child: _isScanning
                    ? QrCodeScanner(
                  setResult: _handleScanResult, // Pass the result handling function
                )
                    : const Center(
                  child: Text(
                    "Scanner QR code",
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      _startSynchronization(); // Start synchronization process
                    },
                    icon: const Icon(Icons.refresh, color: Colors.lightBlue),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isScanning = !_isScanning; // Toggle scanner visibility
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text(_isScanning ? "Stop Scan" : "Scan"),
                  ),
                  IconButton(
                    onPressed: () {
                      // Show the settings popup
                      Settings.showPopup(context);
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
              if (_isSynchronizing) ...[
                const SizedBox(height: 30),
                const CircularProgressIndicator(), // Show progress indicator
                const SizedBox(height: 10),
                Text(_syncStatusMessage), // Show synchronization status
              ],
              const SizedBox(height: 80),
              const Text("ulpgl 2024"),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
