import 'package:flutter/material.dart';

class Devicesize{

  static double? height;
  static double? width;

  void init(BuildContext context){
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
  }
}