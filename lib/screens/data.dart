import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gold/Utils/deviceSize.dart';
import 'package:gold/data/models/goldData.dart';
import 'package:gold/data/repository/datarepository.dart';
import 'package:gold/widgets/button.dart';

class DataScreen extends StatefulWidget {
  DataScreen({super.key, required this.id, required this.currentGoldPrice});
  final int id;
  final double currentGoldPrice;

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    final Golddata data = Datarepository.getData(widget.id);
    List<Uint8List> images = [];
    images.addAll(data.photo);
    images.addAll(data.bill);
    return Scaffold(
      appBar: AppBar(
        title: Text("Asset Data",),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if(details.primaryVelocity! < 0){
                      if(i < images.length-1){
                        setState(() {
                        i++;
                        print(i);
                        });
                      }
                    }
                    if(details.primaryVelocity! > 0){
                      if(i > 0){
                        setState(() {
                        i--;
                        print(i);
                        });
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                    image: DecorationImage(image: Image.memory(images[i]).image, fit: BoxFit.cover),
                      color:  const Color.fromARGB(255, 235, 228, 228),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    height: Devicesize.height!/4,
                    width: Devicesize.width,
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(alignment: Alignment.centerLeft, child: Text(data.name, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      height: Devicesize.height!/8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text("Purchase price", style: TextStyle(fontSize: 20),),
                                Text(data.price.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          VerticalDivider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text("Current value", style: TextStyle(fontSize: 20)),
                                Text("${widget.currentGoldPrice * data.weight}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      height: Devicesize.height!/1.8,
                      width: Devicesize.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Align(alignment: Alignment.centerLeft, child: Text("Purchase Details", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
                            Text(' '),
                            Align(alignment: Alignment.centerLeft, child: Text("Purchase date", style: TextStyle(fontSize: 20),)),
                            Align(alignment: Alignment.centerLeft, child: Text(data.date.toString().split(' ')[0], style: TextStyle(fontSize: 20),)),
                            Text(' '),
                            Align(alignment: Alignment.centerLeft, child: Text("Billed To", style: TextStyle(fontSize: 20),)),
                            Align(alignment: Alignment.centerLeft, child: Text(data.billingName, style: TextStyle(fontSize: 20),)),
                            Text(' '),
                            Align(alignment: Alignment.centerLeft, child: Text("weight", style: TextStyle(fontSize: 20),)),
                            Align(alignment: Alignment.centerLeft, child: Text(data.weight.toString(), style: TextStyle(fontSize: 20),)),
                            Text(' '),
                            Align(alignment: Alignment.centerLeft, child: Text("Wastage", style: TextStyle(fontSize: 20),)),
                            Align(alignment: Alignment.centerLeft, child: Text(data.wastage.toString(), style: TextStyle(fontSize: 20),)),
                            Text(' '),
                            Align(alignment: Alignment.centerLeft, child: Text("Age", style: TextStyle(fontSize: 20),)),
                            Align(alignment: Alignment.centerLeft, child: Text(data.yearsOld.toString(), style: TextStyle(fontSize: 20),)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      height: Devicesize.height!/5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Align(alignment: Alignment.centerLeft, child: Text("Purchase Breakdown", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
               
              Button(text: "Edit Details", function: (){})
              ],
            ),
          ),
        ),
      ),
    );
  }
}

