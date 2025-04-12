import 'package:flutter/material.dart';
import 'package:gold/Utils/deviceSize.dart';
import 'package:gold/Utils/getGoldRateAPI.dart';
import 'package:gold/data/models/goldData.dart';
import 'package:gold/data/repository/datarepository.dart';
import 'package:gold/screens/data.dart';

class Hometab extends StatefulWidget {
  const Hometab({super.key});

  @override
  State<Hometab> createState() => _HometabState();
}

class _HometabState extends State<Hometab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 235, 228, 228),
      body: Center(
        child: Column(
          children: [
            PriceCard(),
            CategoryRow(),
            Saved(data: Datarepository.getAllData(),)
        ],),
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  const PriceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
            color:  const Color.fromARGB(255, 235, 228, 228),
            offset: Offset(0, 6),
            blurRadius: 12,
            spreadRadius: 6,
          )
          ]
        ),
        height: Devicesize.height!/8,
        width: Devicesize.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Current Gold price:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, ),),
              Text("INR ${Getgoldrateapi.data}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryRow extends StatelessWidget {
  const CategoryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Align(alignment: Alignment.centerLeft, child: Text("Category", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Devicesize.height!/12,
                      width: Devicesize.width!/5,
                      decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(40)
                      ),
                      child: Icon(Icons.earbuds),
                    ),
                    Text("Ring")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Devicesize.height!/12,
                      width: Devicesize.width!/5,
                      decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(40)
                      ),
                      child: Icon(Icons.earbuds),
                    ),
                    Text("Necklace")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Devicesize.height!/12,
                      width: Devicesize.width!/5,
                      decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(40)
                      ),
                      child: Icon(Icons.earbuds),
                    ),
                    Text("Gold")
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Saved extends StatelessWidget {
  const Saved({super.key, required this.data});
  final List<Golddata> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10), 
      child: Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: Text("Saved", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),
        Container(
          height: Devicesize.height!/4,
          width: Devicesize.width!/1.1,
          child: GridView.builder(
            itemCount: Datarepository.getDataSize(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
            itemBuilder: (context, index){
              return Card(data: data[index],);
            })
        )
      ],
    ),);
  }
}

class Card extends StatelessWidget {
  const Card({super.key, required this.data});
  final Golddata data;
  
 showData(BuildContext context){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>DataScreen( id: data.id,)));
 }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: (){showData(context);},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          height: Devicesize.height!/4,
          width: Devicesize.width!/2.5,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Image.memory(data.photo[0], fit: BoxFit.cover,),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                height: Devicesize.height!/16,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Name:"),
                        Text(data.name),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}