import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'goldData.g.dart';

@HiveType(typeId: 1)
class Golddata{
  @HiveField(0)
  final int id;

  @HiveField(1)
  final List<Uint8List> photo;

  @HiveField(2)
  final List<Uint8List> bill;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final double weight;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final String type;

  @HiveField(7)
  final String metal;

  @HiveField(8)
  final String purity;

  @HiveField(9)
  final String desc;

  @HiveField(10)
  final String billingName;

  @HiveField(11)
  final int yearsOld;

  @HiveField(12)
  final double wastage;

  @HiveField(13)
  final double tax;

  @HiveField(14)
  final String others;

  @HiveField(15)
  final double price;

  Golddata(this.id, this.photo, this.bill, this.name, this.weight, this.date, this.type, this.metal, this.purity, this.desc, this.billingName, this.yearsOld, this.wastage, this.tax, this.others, this.price);
}