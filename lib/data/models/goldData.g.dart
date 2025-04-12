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
      fields[0] as int,
      (fields[1] as List).cast<Uint8List>(),
      (fields[2] as List).cast<Uint8List>(),
      fields[3] as String,
      fields[4] as double,
      fields[5] as DateTime,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[10] as String,
      fields[11] as int,
      fields[12] as double,
      fields[13] as double,
      fields[14] as String,
      fields[15] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Golddata obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.photo)
      ..writeByte(2)
      ..write(obj.bill)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.metal)
      ..writeByte(8)
      ..write(obj.purity)
      ..writeByte(9)
      ..write(obj.desc)
      ..writeByte(10)
      ..write(obj.billingName)
      ..writeByte(11)
      ..write(obj.yearsOld)
      ..writeByte(12)
      ..write(obj.wastage)
      ..writeByte(13)
      ..write(obj.tax)
      ..writeByte(14)
      ..write(obj.others)
      ..writeByte(15)
      ..write(obj.price);
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
