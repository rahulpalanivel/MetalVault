import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gold/Utils/deviceSize.dart';
import 'package:gold/data/repository/datarepository.dart';
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
    List<Uint8List> bills = [];
    var i = 0;
    var j = 0;

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
    late String type;
    late String metal;
    late String purity;

  Future<void> selectImage() async {
    var pickedFile = await ImagePicker().pickMultiImage();
    images.clear();
    i=0;
    for(var file in pickedFile)
    {
      List<int> imageBytes = (await file.readAsBytes()) as List<int>;
      Uint8List imageUint8List = Uint8List.fromList(imageBytes);
      images.add(imageUint8List);
    }
  }

  Future<void> selectBills() async {
    var pickedFile = await ImagePicker().pickMultiImage();
    bills.clear();
    j=0;
    for(var file in pickedFile)
    {
      List<int> imageBytes = (await file.readAsBytes()) as List<int>;
      Uint8List imageUint8List = Uint8List.fromList(imageBytes);
      bills.add(imageUint8List);
    }
  }

  void addToDb(){
    Datarepository.addNewData(images, bills, name.text, double.parse(weight.text), DateTime.parse(date.text), type, metal, purity, desc.text, billingName.text, parseDate(date.text), double.parse(wastage.text), double.parse(tax.text), others.text, double.parse(price.text));
  }

  int parseDate(String date){
    var years = 0;
    DateTime nowdate = DateTime.now();
    DateTime find = DateTime.parse(date);
    var yrs = find.year - nowdate.year;
    return years;
  }

  void clearAll(){
    setState(() {
      List<Uint8List> images = [];
      List<Uint8List> bills = [];
      var i = 0;
      var j = 0;

      name.clear();
      weight.clear();
      date.clear(); 
      desc.clear(); 
      billingName.clear(); 
      yrs.clear(); 
      wastage.clear(); 
      tax.clear(); 
      others.clear(); 
      price.clear(); 
      type = "";
      metal = "";
      purity = "";
    });
  }
  

  @override
  Widget build(BuildContext context) {
    
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
                        
                        selectImage().whenComplete(()=> setState(() {
                        }));
                        
                      }, child: Text("Upload"))),
                    ) : 
                    GestureDetector(
                      onTap: () {
                        selectImage().whenComplete(()=> setState(() {
                          }));
                      },
                      onHorizontalDragEnd: (details) {
                        if(details.primaryVelocity! < 0){
                          if(i < images.length-1){
                            setState(() {
                            i++;
                            });
                          }
                        }
                        if(details.primaryVelocity! > 0){
                          if(i > 0){
                            setState(() {
                            i--;
                            });
                          }
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
                    bills.isEmpty?
                    OutlinedButton(onPressed: (){
                      selectBills().whenComplete(()=> setState(() {
                      }));
                    }, child: Text("Upload")) :
                    TextButton(onPressed: (){
                      selectBills().whenComplete(()=>setState(() {
                      }));
                    }, child: Text("Bills"))
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
                        Dropdown(items: ["Ring", "Earring", "Chain", "Bangle", "Necklace", "Other"], defaultItem: "Other", updatedValue: (String value){ type = value;})
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
                        Dropdown(items: ["Gold", "Silver", "Other"], defaultItem: "Other", updatedValue: (String value){metal = value;})
                      ],
                    ),
                    Column(
                      children: [
                        Text("Purity"),
                        Dropdown(items: ["GIS", "916", "Other"], defaultItem: "Other", updatedValue: (String value){purity = value;})
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
              child: Column(
                children: [
                  Text("Jwellery Name:"),
                  TextBox(name: billingName, height: Devicesize.height!/15, width: Devicesize.width,)
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
                child: Button(text: "Save", function: (){
                  addToDb();
                  clearAll();
                }),
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