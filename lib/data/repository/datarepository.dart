import 'dart:typed_data';

import 'package:gold/data/models/goldData.dart';
import 'package:hive/hive.dart';

class Datarepository {
  static final DataBox = Hive.box('DataBox');

  static int getDataSize(){
    return DataBox.length;
  }

  static void addNewData(List<Uint8List> photo, List<Uint8List> bill, String name, double weight, DateTime date, String type, String metal, String purity, String desc, String billingName, int yearsOld, double wastage, double tax, String others, double price){
    int id = getDataSize()+1;
    var data = Golddata(
        id, 
        photo, 
        bill, 
        name, 
        weight, 
        date, 
        type, 
        metal, 
        purity, 
        desc, 
        billingName, 
        yearsOld, 
        wastage, 
        tax, 
        others,
        price
      );
    DataBox.put(id, data);
  }

  static List<Golddata> getAllData(){
    List<Golddata> dataList = [];
    for(int i=0; i<DataBox.length; i++){
      var data = Golddata(
        DataBox.getAt(i).id, 
        DataBox.getAt(i).photo, 
        DataBox.getAt(i).bill, 
        DataBox.getAt(i).name, 
        DataBox.getAt(i).weight, 
        DataBox.getAt(i).date, 
        DataBox.getAt(i).type, 
        DataBox.getAt(i).metal, 
        DataBox.getAt(i).purity, 
        DataBox.getAt(i).desc, 
        DataBox.getAt(i).billingName, 
        DataBox.getAt(i).yearsOld, 
        DataBox.getAt(i).wastage, 
        DataBox.getAt(i).tax, 
        DataBox.getAt(i).others,
        DataBox.getAt(i).price
      );
      dataList.add(data);
    }
    return dataList;
  }

  static Golddata getData(int id){
    Golddata data = DataBox.values.toList().where((element)=>element.id == id).first;
    return data;
  }

  static double getPurchaseVal(){
    double val = 0;
    for(int i=1; i<=DataBox.length; i++){
      val = val + DataBox.get(i).price;
    }
    return val;
  }

  static double getTotalWeight(){
    double gram = 0;
    for(int i=1; i<=DataBox.length; i++){
      gram = gram + DataBox.get(i).weight;
    }
    return gram;
  }
}