import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gold/Utils/deviceSize.dart';
import 'package:gold/widgets/button.dart';
import 'package:gold/widgets/datepicker.dart';
import 'package:gold/widgets/dropDown.dart';
import 'package:image_picker/image_picker.dart';

class Addnewtab extends StatefulWidget {
  const Addnewtab({super.key});

  @override
  State<Addnewtab> createState() => _AddnewtabState();
}

class _AddnewtabState extends State<Addnewtab> {
List<Uint8List> images = [];
var i = 0;

  Future<void> selectImage() async {
    var pickedFile = await ImagePicker().pickMultiImage();
    for(var file in pickedFile)
    {
      List<int> imageBytes = (await file.readAsBytes()) as List<int>;
      Uint8List imageUint8List = Uint8List.fromList(imageBytes);
      images.add(imageUint8List);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController weight = TextEditingController();
    TextEditingController date = TextEditingController(text: DateTime.now().toString());
    TextEditingController desc = TextEditingController();
    TextEditingController billingName = TextEditingController();
    TextEditingController yrs = TextEditingController();
    TextEditingController wastage = TextEditingController();
    TextEditingController tax = TextEditingController();
    TextEditingController others = TextEditingController();
    TextEditingController price = TextEditingController();
    String Type;
    String Metal;
    String Purity;
    return Scaffold(
      backgroundColor:  Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Column(
                  children: [
                    Text("Upload Image:"),
                    images.isEmpty ?
                    Container(
                      decoration: BoxDecoration(
                        color:  const Color.fromARGB(255, 235, 228, 228),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      height: Devicesize.height!/6,
                      width: Devicesize.width,
                      child: Center(child: OutlinedButton(onPressed: (){
                        setState(() {
                          selectImage().whenComplete(()=> setState(() {
                          }));
                        });
                      }, child: Text("Upload"))),
                    ) : 
                    GestureDetector(
                      onTap: () {
                        
                      },
                      onHorizontalDragEnd: (details) {
                        if(i < images.length-1){
                          setState(() {
                          i++;
                        });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:  const Color.fromARGB(255, 235, 228, 228),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        height: Devicesize.height!/6,
                        width: Devicesize.width,
                        child: Image.memory(images[i], fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Upload Bills:"),
                    OutlinedButton(onPressed: (){}, child: Text("Upload"))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("Name: "),
                        TextBox(name: name, height: Devicesize.height!/15, width: Devicesize.width!/1.5)
                      ],
                    ),
                    Column(
                      children: [
                        Text("Weight"),
                        TextBox(name: weight, height: Devicesize.height!/15, width: Devicesize.width!/4)
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("Purchase Date"),
                        Datepicker(dateController: date)
                      ],
                    ),
                    Column(
                      children: [
                        Text("Type"),
                        Dropdown(items: ["Ring", "Earring", "Chain", "Other"], defaultItem: "Other", updatedValue: (String value){ Type = value;})
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("Metal"),
                        Dropdown(items: ["Gold", "Silver", "Other"], defaultItem: "Other", updatedValue: (String value){Metal = value;})
                      ],
                    ),
                    Column(
                      children: [
                        Text("Purity"),
                        Dropdown(items: ["GIS", "916", "Other"], defaultItem: "Other", updatedValue: (String value){Purity = value;})
                      ],
                    ),
                  ],
                ), 
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Text("Description:"),
                    TextBox(name: desc, height: Devicesize.height!/15, width: Devicesize.width,)
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(5), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Billing Name:"),
                      TextBox(name: billingName, height: Devicesize.height!/15, width: Devicesize.width!/1.5,)
                    ],
                  ),
                  Column(children: [
                    Text("Years old"),
                    TextBox(name: yrs, height: Devicesize.height!/15, width: Devicesize.width!/4,)
                  ],)
                ],
              ),),
              Padding(padding: EdgeInsets.all(5), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Wastage:"),
                      TextBox(name: wastage, height: Devicesize.height!/15, width: Devicesize.width!/3.3)
                    ],
                  ),
                  Column(
                    children: [
                      Text("Tax:"),
                      TextBox(name: tax, height: Devicesize.height!/15, width: Devicesize.width!/3.3)
                    ],
                  ), 
                  Column(
                    children: [
                      Text("Others:"),
                      TextBox(name: others, height: Devicesize.height!/15, width: Devicesize.width!/3.3)
                  ],)
                ],
              ),),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Text("Total Price:"),
                    TextBox(name: price, height: Devicesize.height!/15, width: Devicesize.width,)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Button(text: "Save", function: (){}),
              ),
          ],),
        ),
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  const TextBox({super.key, required this.name, required this.height, required this.width});
  final TextEditingController name;
  final height;
  final width;

  @override
  Widget build(BuildContext context) {
    return Container(height: height, width: width, 
      child: TextField(
        controller: name,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.grey, width: 2
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.grey, width: 2
            )
          )
        ),
      )
    );
  }
}