// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalculationAdapter extends TypeAdapter<Calculation> {
  @override
  final int typeId = 0;

  @override
  Calculation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Calculation(
      expression: fields[0] as String,
      result: fields[1] as String,
      note: fields[2] as String,
      time: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Calculation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.expression)
      ..writeByte(1)
      ..write(obj.result)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
