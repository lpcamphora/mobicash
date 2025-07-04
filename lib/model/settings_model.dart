import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 2)
class SettingsModel extends HiveObject {
  @HiveField(0)
  List<String> categorias;

  @HiveField(1)
  List<String> cartoes;

  SettingsModel({
    required this.categorias,
    required this.cartoes,
  });
}
