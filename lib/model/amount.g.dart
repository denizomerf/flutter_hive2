// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amount.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AmountModelAdapter extends TypeAdapter<AmountModel> {
  @override
  final int typeId = 0;

  @override
  AmountModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AmountModel()
      ..name = fields[0] as String
      ..amount = fields[1] as double
      ..isPlus = fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, AmountModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.isPlus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmountModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
