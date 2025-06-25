// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gasto_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GastoModelAdapter extends TypeAdapter<GastoModel> {
  @override
  final int typeId = 0;

  @override
  GastoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GastoModel(
      descricao: fields[0] as String,
      valor: fields[1] as double,
      data: fields[2] as DateTime,
      categoria: fields[3] as String,
      cartao: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GastoModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.descricao)
      ..writeByte(1)
      ..write(obj.valor)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.categoria)
      ..writeByte(4)
      ..write(obj.cartao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GastoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
