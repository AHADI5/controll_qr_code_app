import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v1/widgets/Settings.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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

                  )]
                ),
                margin: const EdgeInsets.all(15),
                width: 400,
                height: 400,


              ),
              //here will be the scanner
              //TODO THE SCANNER CONTAINER

              //action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () =>{},
                      icon: const Icon(Icons.refresh , color: Colors.lightBlue,)
                  ) ,
                  ElevatedButton(
                      onPressed: () {

                      },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.white),

                    ),
                      child:const Text("Scan"),
                  ),

                  IconButton(
                      onPressed: (){
                        //Showing up popup
                        Settings.showPopup(context);
                      },
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
