import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 2)
class SettingsModel extends HiveObject {
  @HiveField(0)
  List<String> categoriasDespesas;

  @HiveField(1)
  List<String> categoriasReceitas;

  @HiveField(2)
  List<String> cartoes;

  SettingsModel({
    required this.categoriasDespesas,
    required this.categoriasReceitas,
    required this.cartoes,
  });
}
