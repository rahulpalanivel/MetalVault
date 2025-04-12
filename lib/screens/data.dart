import 'package:flutter/material.dart';
import 'package:gold/Utils/deviceSize.dart';
import 'package:gold/data/models/goldData.dart';
import 'package:gold/data/repository/datarepository.dart';

class DataScreen extends StatelessWidget {
  DataScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    final Golddata data = Datarepository.getData(id);
    return Scaffold(
      appBar: AppBar(
        title: Text("Asset Data",),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:  const Color.fromARGB(255, 235, 228, 228),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  height: Devicesize.height!/6,
                  width: Devicesize.width,
                  child: Image.memory(data.photo[0], fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}