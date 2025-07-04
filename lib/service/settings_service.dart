import 'package:hive/hive.dart';
import '../model/settings_model.dart';

class SettingsService {
  static const String boxName = 'settingsBox';

  Future<SettingsModel> carregarOuCriarPadrao() async {
    final box = await Hive.openBox<SettingsModel>(boxName);
    final dados = box.get('prefs');

    if (dados != null) return dados;

    final novo = SettingsModel(
      categorias: ['Alimentação', 'Transporte', 'Lazer', 'Saúde'],
      cartoes: ['Débito Itaú', 'Crédito Nubank', 'Pix', 'Dinheiro'],
    );

    await box.put('prefs', novo);
    return novo;
  }

  Future<void> salvar(SettingsModel settings) async {
    final box = await Hive.openBox<SettingsModel>(boxName);
    await box.put('prefs', settings);
  }
}
