import 'package:flutter/material.dart';
import 'package:gold/screens/home.dart';
import 'package:gold/widgets/button.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(color: const Color.fromARGB(255, 235, 228, 228), 
        child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            Text("Gold App", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.amber),),
            Button(text: 'Open', function: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
            },),
        ],))),
    );
  }
}