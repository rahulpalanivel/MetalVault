import 'package:flutter/material.dart';
import 'package:gold/Utils/deviceSize.dart';
import 'package:gold/Utils/getGoldRateAPI.dart';
import 'package:gold/models/goldData.dart';
import 'package:gold/screens/start.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;


void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path); 
  Hive.registerAdapter(GolddataAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    Devicesize().init(context);
    //Getgoldrateapi.fetchData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gold App',
      home: const Start(),
    );
  }
}