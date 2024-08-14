import 'package:flutter/material.dart';
import 'package:v1/widgets/Home.dart'; // Import the Home widget for rescanning

class VerificationResultPage extends StatelessWidget {
  final bool isInOrder;
  final double amount;
  final String name;
  final double requiredAmount  ;

  const VerificationResultPage(
      {super.key,
      required this.isInOrder,
      required this.amount,
      required this.name, required this.requiredAmount});

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
              fontSize: 10
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${name.toUpperCase()}  " , style:  TextStyle( fontWeight: FontWeight.bold,
              fontSize: 24,),),
            Icon(
              isInOrder ? Icons.check_circle : Icons.error,
              color: isInOrder ? Colors.green : Colors.red,
              size: 100,
            ),
            const SizedBox(height: 12),
            Text(
              isInOrder ? "En ordre!" : "Pas en ordre",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isInOrder ? Colors.green : Colors.red,
              ),
            ),
            Text("_______________________________" , style: TextStyle(fontSize: 18 ,  fontWeight: FontWeight.bold)),

            Text("Montant recquis :" , style: TextStyle(fontSize: 18 ,  fontWeight: FontWeight.bold)),
            Text(
              "\$ ${requiredAmount}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text("_______________________________" , style: TextStyle(fontSize: 18 ,  fontWeight: FontWeight.bold)),
            Text("Montant payé :" , style: TextStyle(fontSize: 18 ,  fontWeight: FontWeight.bold)),
            Text(
              "\$ ${amount}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text("_______________________________" , style: TextStyle(fontSize: 18 ,  fontWeight: FontWeight.bold)),
            Text( "Reste :" , style: TextStyle(fontSize: 18 ,  fontWeight: FontWeight.bold ),) ,

            Text( "\$ ${(requiredAmount - amount).toString()} " , style:  TextStyle(color: Colors.red , fontSize: 24),) ,
            Text("_______________________________" , style: TextStyle(fontSize: 18 ,  fontWeight: FontWeight.bold)),

            const SizedBox(height: 40),
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
        ),
      ),
    );
  }
}
