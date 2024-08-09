import 'package:flutter/material.dart';
import 'package:v1/widgets/Home.dart';

void main() => runApp(const MainApp());


class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF5F5F5)
      ),
      debugShowCheckedModeBanner: false,
      title: "Control App",
      initialRoute: "/" ,
      routes: {
        "/" :  (context) =>  Home()
      },

    );
  }
}
