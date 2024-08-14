import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr_code_scanner;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:v1/services/services.dart';
import 'package:v1/widgets/Settings.dart';
import 'package:v1/services/synchronisation.dart';
import 'package:v1/widgets/Result.dart';
import 'package:v1/widgets/error.dart';
import '../model/models.dart';
import 'Verification.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final DatabaseService _databaseService = DatabaseService();
  bool _isSynchronizing = false;
  String _syncStatusMessage = '';
  bool _isScanning = false;
  bool _isVerifying = false;
  bool _isAmountSet = false;
  bool _isApiSet = false ;
  String _amountMessage = '';
  double _verificationAmount = 0.0; // Define verification amount
  String _api = '' ;
  qr_code_scanner.QRViewController? controller;
  mobile_scanner.Barcode? result;

  final GlobalKey qrkey = GlobalKey(debugLabel: "QR");
  late AnimationController _animationController;
  late Animation<Offset> _animation;


  @override
  void initState() {
    super.initState();
    _loadVerificationAmount();
    _loadApi();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Repeats the animation indefinitely

    // Define the slide animation
    _animation = Tween<Offset>(
      begin: Offset(0, 0.0),
      end: Offset(0, 0.5),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,

    ));
  }

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
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadVerificationAmount() async {
    try {
      _verificationAmount = await _databaseService.getAmount();
      setState(() {
        _isAmountSet = true;
        _amountMessage = '\$${_verificationAmount.toStringAsFixed(2)}';
      });
    } catch (e) {
      setState(() {
        _isAmountSet = false;
        _amountMessage = 'Pas de montant de vérification';
      });
    }
  }

  Future<void> _loadApi() async {
    try {
      _api = await _databaseService.getApi();
      setState(() {
        _isApiSet = true;
        _amountMessage = '\$${_verificationAmount.toStringAsFixed(2)}';
      });
    } catch (e) {
      setState(() {
        _isApiSet= false;
        _amountMessage = 'Pas de montant de vérification';
      });
    }
  }

  Future<void> _startSynchronization() async {
    setState(() {
      _isSynchronizing = true;
      _syncStatusMessage = 'Synchronizing...';
    });

    try {
      SyncService syncService = SyncService();
      await syncService
          .synchronizeWithServer(_api);

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
      appBar: AppBar(
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Center(
              child: Text(
                "ULPGL-FINCHECK-TOOL",
                style: TextStyle(
                    letterSpacing: 4.5,
                    color: Colors.lightBlue ,
                  fontSize: 10
                ),
              ),
            ),

            IconButton(
              onPressed: () async {
                await Settings.showPopupApi(context, (api) {
                  setState(() {
                    _api = api;
                  });
                });
                _loadApi(); // Reload amount after registering new one
              },
              icon: const Icon(Icons.settings),
            ),

          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(_api),
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
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Stack(
                          children: [
                            _isScanning
                                ? qr_code_scanner.QRView(
                              onPermissionSet: (ctrl, p) =>
                                  _onPermissionSet(context, ctrl, p),
                              key: qrkey,
                              onQRViewCreated: _onQRViewCreated,
                            )
                                : Center(child: QrImageView.new(data: '',)),
                            if (_isScanning)
                              Positioned.fill(
                                child: SlideTransition(
                                  position: _animation,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 30.0),
                                      height: 4.0,
                                      width: MediaQuery.of(context).size.width * 0.7,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            if (_isVerifying)
                              const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 10),
                                    Text('Vérification en cours...'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                    onPressed: _isAmountSet
                        ? () {
                      setState(() {
                        _isScanning = !_isScanning;
                      });
                    }
                        : null, // Disable the button if no amount is set
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          _isAmountSet ? Colors.blueAccent : Colors.grey),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text(_isScanning ? "Stop Scan" : "Scan"),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Settings.showPopup(context, (newAmount) {
                        setState(() {
                          _verificationAmount = newAmount;
                        });
                      });
                      _loadVerificationAmount(); // Reload amount after registering new one
                    },
                    icon: const Icon(Icons.currency_exchange_rounded),
                  ),
                ],
              ),
              if (_isSynchronizing) ...[
                const SizedBox(height: 30),
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text(_syncStatusMessage),
              ],
              const SizedBox(height: 20),
              Column(
                children: [
                  const Text("Montant requis :" , style: TextStyle(fontSize: 20),),
                  Text(
                    ' \$ ${_verificationAmount.toString()}',
                    style: const TextStyle(fontSize: 18.0  , fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  const Text("© ULPGL 2024. Tous droits réservés." , style: const TextStyle(fontSize: 12.0),),
                ],

              ),

              const SizedBox(height: 15),
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
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.format == qr_code_scanner.BarcodeFormat.qrcode &&
          scanData.code != null &&
          scanData.code!.isNotEmpty) {
        controller.pauseCamera();
        setState(() {
          _isVerifying = true;
          _isScanning = false;
          _animationController.stop(); // Stop the animation once QR is found
        });
        await navigateToNextScreen(scanData.code!);
        setState(() {
          _isVerifying = false;
        });
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
    final int studentID = int.parse(qrData); // Convert scanned result to studentID

    // getting the student for result issues
    try {
      final Student? student = await _databaseService.getStudentByID(studentID);

      if (student == null) {
        // Navigate to the ErrorPage if the student is not found
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ErrorPage(),
          ),
        );
        return; // Exit the function to prevent further execution
      }

      final Verification verification = Verification();
      final bool isInOrder = await verification.checkStudent(studentID);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationResultPage(
            isInOrder: isInOrder,
            amount: student.payedAmount,
            name: student.name,
            requiredAmount: _verificationAmount,
          ),
        ),
      );
    } catch (e) {
      // Handle any errors by logging them and returning false
      print("Error retrieving student or amount: $e");

      // Optionally navigate to an error page or handle the error in another way
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ErrorPage(),
        ),
      );
    }
  }

}
