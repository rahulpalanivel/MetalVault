// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goldData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GolddataAdapter extends TypeAdapter<Golddata> {
  @override
  final int typeId = 1;

  @override
  Golddata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Golddata(
      (fields[0] as List).cast<String>(),
      (fields[1] as List).cast<String>(),
      fields[2] as String,
      fields[3] as double,
      fields[4] as DateTime,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[10] as int,
      fields[11] as double,
      fields[12] as double,
      fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Golddata obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.photo)
      ..writeByte(1)
      ..write(obj.bill)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.metal)
      ..writeByte(7)
      ..write(obj.purity)
      ..writeByte(8)
      ..write(obj.desc)
      ..writeByte(9)
      ..write(obj.billingName)
      ..writeByte(10)
      ..write(obj.yearsOld)
      ..writeByte(11)
      ..write(obj.wastage)
      ..writeByte(12)
      ..write(obj.tax)
      ..writeByte(13)
      ..write(obj.others);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GolddataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
