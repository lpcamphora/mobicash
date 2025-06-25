import 'package:hive_flutter/hive_flutter.dart';
import '../model/gasto_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(GastoModelAdapter());
  await Hive.openBox<GastoModel>('gastos');
}
