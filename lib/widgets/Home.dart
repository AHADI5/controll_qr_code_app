import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:v1/widgets/Settings.dart';
import 'package:v1/widgets/qr_code_scanner.dart'; // Ensure this path is correct

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isScanning = false; // State to determine if the scanner is visible

  // Function to handle the scan result and display it in a popup dialog
  void _handleScanResult(String? result) {
    if (result != null) {
      // Display the result in a popup dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Scan Result"),
            content: Text("Scanned QR code: $result"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );

      // Stop scanning and update the state
      setState(() {
        _isScanning = false;
      });
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
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
                      // Add functionality for refresh button if needed
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
