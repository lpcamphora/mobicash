import 'package:hive_flutter/hive_flutter.dart';
import '../model/gasto_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  // Registra o enum primeiro
  Hive.registerAdapter(TipoLancamentoAdapter());

  // Depois o modelo
  Hive.registerAdapter(GastoModelAdapter());

  await Hive.openBox<GastoModel>('gastos');
}
