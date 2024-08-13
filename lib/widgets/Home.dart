import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr_code_scanner;
import 'package:v1/widgets/Settings.dart';
import 'package:v1/services/synchronisation.dart';
import 'package:v1/widgets/Result.dart';
import 'Verification.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isSynchronizing = false;
  String _syncStatusMessage = '';
  bool _isScanning = false;
  qr_code_scanner.QRViewController? controller;
  mobile_scanner.Barcode? result;

  final GlobalKey qrkey = GlobalKey(debugLabel: "QR");

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
    super.reassemble();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _startSynchronization() async {
    setState(() {
      _isSynchronizing = true;
      _syncStatusMessage = 'Synchronizing...';
    });

    try {
      SyncService syncService = SyncService();
      await syncService
          .synchronizeWithServer('http://192.168.43.178:8080/api/v1/students/');

      setState(() {
        _isSynchronizing = false;
        _syncStatusMessage = 'Synchronized';
      });
    } catch (e) {
      setState(() {
        _isSynchronizing = false;
        _syncStatusMessage = 'Synchronization failed';
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
                child:
                     qr_code_scanner.QRView(
                  onPermissionSet: (ctrl, p) =>
                      _onPermissionSet(context, ctrl, p),
                  key: qrkey,
                  onQRViewCreated: _onQRViewCreated,
                )

              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      _startSynchronization();
                    },
                    icon: const Icon(Icons.refresh, color: Colors.lightBlue),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isScanning = !_isScanning;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.blueAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text(_isScanning ? "Stop Scan" : "Scan"),
                  ),
                  IconButton(
                    onPressed: () {
                      Settings.showPopup(context);
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
              if (_isSynchronizing) ...[
                const SizedBox(height: 30),
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text(_syncStatusMessage),
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

  void _onQRViewCreated(qr_code_scanner.QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData.format == qr_code_scanner.BarcodeFormat.qrcode &&
          scanData.code != null && scanData.code!.isNotEmpty) {
        controller.pauseCamera();
        navigateToNextScreen(scanData.code!);
      }
    });
  }

  void _onPermissionSet(
      BuildContext context, qr_code_scanner.QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  Future<void> navigateToNextScreen(String qrData) async {
    final int studentID =
    int.parse(qrData); // Convert scanned result to studentID
    final Verification verification = Verification();
    final bool isInOrder = await verification.checkStudent(studentID);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationResultPage(
          isInOrder: isInOrder,
        ),
      ),
    );
  }
}
