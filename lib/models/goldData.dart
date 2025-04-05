import 'package:hive/hive.dart';
part 'goldData.g.dart';

@HiveType(typeId: 1)
class Golddata{
  @HiveField(0)
  final List<String> photo;
  @HiveField(1)
  final List<String> bill;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final double weight;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  final String type;
  @HiveField(6)
  final String metal;
  @HiveField(7)
  final String purity;
  @HiveField(8)
  final String desc;
  @HiveField(9)
  final String billingName;
  @HiveField(10)
  final int yearsOld;
  @HiveField(11)
  final double wastage;
  @HiveField(12)
  final double tax;
  @HiveField(13)
  final String others;
  Golddata(this.photo, this.bill, this.name, this.weight, this.date, this.type, this.metal, this.purity, this.desc, this.billingName, this.yearsOld, this.wastage, this.tax, this.others);
}