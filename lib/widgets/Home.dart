import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 110),
              Container(
                margin: const EdgeInsets.all(10),
                width: 400,
                height: 400,
                color: Colors.grey,

              ),
              //here will be the scanner
              //TODO THE SCANNER CONTAINER
              //TODO ACTION BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () =>{}, 
                      icon: const Icon(Icons.refresh , color: Colors.lightBlue,)
                  ) ,
                  ElevatedButton(
                      
                      onPressed: () =>{},
                      child:const Text("Scan") ),
                  IconButton(
                      onPressed: () =>{},
                      icon: const Icon(Icons.settings))
                ],
              ),
              
              //const SizedBox(height: 100) ,
              const Text("ulpgl 2024")
              
            ],
          )),


    );
  }
}
