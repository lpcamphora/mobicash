import 'package:hive/hive.dart';

part 'gasto_model.g.dart';

@HiveType(typeId: 0)
class GastoModel extends HiveObject {
  @HiveField(0)
  final String descricao;

  @HiveField(1)
  final double valor;

  @HiveField(2)
  final DateTime data;

  @HiveField(3)
  final String categoria;

  @HiveField(4)
  final String cartao;

  GastoModel({
    required this.descricao,
    required this.valor,
    required this.data,
    required this.categoria,
    required this.cartao,
  });
}
