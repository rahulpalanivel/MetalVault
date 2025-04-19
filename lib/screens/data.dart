import 'package:flutter/material.dart';
import 'package:gold/Utils/deviceSize.dart';
import 'package:gold/data/models/goldData.dart';
import 'package:gold/data/repository/datarepository.dart';
import 'package:gold/widgets/button.dart';

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
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onHorizontalDragEnd: (details) {
            
                },
                child: Container(
                  decoration: BoxDecoration(
                  image: DecorationImage(image: Image.memory(data.photo[0]).image, fit: BoxFit.cover),
                    color:  const Color.fromARGB(255, 235, 228, 228),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  height: Devicesize.height!/4,
                  width: Devicesize.width,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Devicesize.width!/1.7,
                      child: Column(
                        children: [
                          Align(alignment: Alignment.centerLeft, child: Text(data.name, style: TextStyle(fontSize: 30,),)),
                          Align(alignment: Alignment.centerLeft, child: Text(data.desc, style: TextStyle(fontSize: 16,))),
                        ],
                      ),
                    ),
                    Container(
                      width: Devicesize.width!/3,
                      child: Column(
                        children: [
                          Align(alignment: Alignment.centerRight, child: Text('\$${data.price}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)),
                          Align(alignment: Alignment.centerRight, child: Text("${data.weight}g", style: TextStyle(fontSize: 16,))),
                        ],
                      )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Devicesize.width!/1.9,
                      child: Column(
                        children: [
                          Align(alignment: Alignment.centerLeft, child: Text("Billing Name", style: TextStyle(fontSize: 18),)),
                          Align(alignment: Alignment.centerLeft, child: Text(data.billingName, style: TextStyle(fontSize: 26),),)
                        ],
                      ),
                    ),
                    Container(
                      width: Devicesize.width!/2.6,
                      child: Column(
                        children: [
                          Align(alignment: Alignment.centerRight, child: Text(data.date.toString().split(" ")[0], style: TextStyle(fontSize: 24),)),
                          Align(alignment: Alignment.centerRight, child: Text("Years old: ${data.yearsOld.toString()}", style: TextStyle(fontSize: 20),)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Devicesize.width!/2,
                      child: Column(
                        children: [
                          Align(alignment: Alignment.centerLeft,child:  Text("Type: ${data.type}", style: TextStyle(fontSize: 22),)),
                          Align(alignment: Alignment.centerLeft,child:  Text("Metal: ${data.metal}", style: TextStyle(fontSize: 22),)),
                          Align(alignment: Alignment.centerLeft,child:  Text("Purity: ${data.purity}", style: TextStyle(fontSize: 22),)),
                        ],
                      ),
                    ),
                    Container(
                      width: Devicesize.width!/2.5,
                      child: Column(
                        children: [
                          Align(alignment: Alignment.centerRight, child: Text("Wastage: ${data.wastage.toString()}", style: TextStyle(fontSize: 22),)),
                          Align(alignment: Alignment.centerRight, child: Text("Tax: ${data.tax.toString()}", style: TextStyle(fontSize: 22),)),
                          Align(alignment: Alignment.centerRight, child: Text("Others: ${data.others}", style: TextStyle(fontSize: 22),)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
             Padding(
               padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
               child: Container(
                child: Column(
                  children: [
                    Align(child: Text("Current Price: ", style: TextStyle(fontSize: 24),)),
                    Align(child: Text("\$10,000", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),)),
                  ],
                ),
               ),
             ),
            Button(text: "Edit Details", function: (){})

              
              
              
              
            ],
          ),
        ),
      ),
    );
  }
}