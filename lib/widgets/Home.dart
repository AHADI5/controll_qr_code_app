import 'package:flutter/material.dart';
import 'package:v1/widgets/Settings.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Ajout de SingleChildScrollView pour le défilement
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                width: MediaQuery.of(context).size.width * 0.9, // Largeur réactive
                height: MediaQuery.of(context).size.height * 0.5, // Hauteur réactive
                child: Center(
                  child: Text('Scanner goes here'), // Placeholder pour le scanner
                ),
              ),

              SizedBox(height: 30,),
              // Boutons d'action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh, color: Colors.lightBlue),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: const Text("Scan"),
                  ),
                  IconButton(
                    onPressed: () {
                      // Afficher le popup
                      Settings.showPopup(context);
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
              const SizedBox(height: 80), // Ajouter de l'espace pour le texte
              const Text("ulpgl 2024"),
              const SizedBox(height: 20), // Ajouter de l'espace en bas pour le défilement
            ],
          ),
        ),
      ),
    );
  }
}
