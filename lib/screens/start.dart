/*import 'package:flutter/material.dart';
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
}*/
import 'package:flutter/material.dart';
import 'package:gold/screens/home.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A1818), // Darker background
              Color(0xFF282828),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo: Increased gold color intensity
                Icon(
                  Icons.monetization_on,
                  size: 120, // Increased size
                  color: const Color(0xFFFFD700), // Pure Gold
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 15,
                      offset: const Offset(4, 4),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  "Gold Tracker",
                  style: const TextStyle(
                    fontSize: 52, // Increased size
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700), // Pure Gold
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        blurRadius: 12.0, // Increased blur
                        color: Colors.black,
                        offset: Offset(3.0, 3.0),
                      ),
                    ],
                    fontFamily: 'serif',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60), // Increased spacing
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700), // Pure Gold
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Increased padding
                    textStyle: const TextStyle(
                      fontSize: 20, // Increased size
                      fontWeight: FontWeight.w700, // Make it extra bold
                      fontFamily: 'sans-serif',
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // More rounded
                      side: const BorderSide(color: Color(0xFFFFD700), width: 2), // Gold border
                    ),
                    elevation: 10, // Increased elevation
                    shadowColor: Colors.black.withOpacity(0.6), // Stronger shadow
                  ),
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
