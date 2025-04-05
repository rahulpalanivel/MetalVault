import 'package:flutter/material.dart';
import 'package:gold/Utils/deviceSize.dart';

class Button extends StatelessWidget {
  const Button({super.key,  required this.text, required this.function});
  final String text;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(0, 220, 175, 11),
              offset: Offset(6, 6),
              blurRadius: 12,
              spreadRadius: 6
            )
          ]
        ),
        height: Devicesize.height!/12,
        width: Devicesize.width!/2,
        child: Center(child: Text(text, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),)),
      ),
    );
  }
}