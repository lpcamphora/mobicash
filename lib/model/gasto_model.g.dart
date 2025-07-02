// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gasto_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GastoModelAdapter extends TypeAdapter<GastoModel> {
  @override
  final int typeId = 1;

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
      tipo: fields[5] as TipoLancamento,
    );
  }

  @override
  void write(BinaryWriter writer, GastoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.descricao)
      ..writeByte(1)
      ..write(obj.valor)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.categoria)
      ..writeByte(4)
      ..write(obj.cartao)
      ..writeByte(5)
      ..write(obj.tipo);
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

class TipoLancamentoAdapter extends TypeAdapter<TipoLancamento> {
  @override
  final int typeId = 0;

  @override
  TipoLancamento read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TipoLancamento.receita;
      case 1:
        return TipoLancamento.despesa;
      default:
        return TipoLancamento.receita;
    }
  }

  @override
  void write(BinaryWriter writer, TipoLancamento obj) {
    switch (obj) {
      case TipoLancamento.receita:
        writer.writeByte(0);
        break;
      case TipoLancamento.despesa:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipoLancamentoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
