import 'package:flutter/material.dart';
import 'package:gold/tabs/addNewTab.dart';
import 'package:gold/tabs/homeTab.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int screenIdx = 0;
  List screen = [
    Hometab(), Addnewtab()
  ];
  List screenName = [
    "Dashboard", "Add new Asset"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Align(alignment: Alignment.centerLeft, child: Text(screenName[screenIdx]))),
      bottomNavigationBar: BottomAppBar(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          GestureDetector(
            onTap: () {
              setState(() {
                screenIdx = 0;
              });
            },
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home),
              Text("Home")
            ],
          ),),
          GestureDetector(
            onTap: () {
              setState(() {
                screenIdx = 1;
              });
            },
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_box),
              Text("Add New")
            ],
          ),),
          GestureDetector(
            onTap: () {},
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.settings),
              Text("Settings")
            ],
          ),),
        ],),
      ),
      body: screen[screenIdx],

    );
  }
}