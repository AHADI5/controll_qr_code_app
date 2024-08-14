import 'package:flutter/material.dart';
import 'package:v1/widgets/Home.dart'; // Import the Home widget for rescanning

class ErrorPage extends StatelessWidget {


  const ErrorPage(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:    const Center(
          child: Text(
            "ULPGL-FINCHECK-TOOL",
            style: TextStyle(
                letterSpacing: 4.5,
                color: Colors.lightBlue ,
                fontSize: 15
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Center(
           child:  Text("L'étudiant n'existe pas dans le système" , style: TextStyle(
             fontWeight: FontWeight.bold , color: Colors.red
           ),)
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text("Rescan"),
            style: ElevatedButton.styleFrom(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      )
    );
  }
}
