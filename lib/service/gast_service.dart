import 'package:hive/hive.dart';
import '../model/gasto_model.dart';

class GastoService {
  final Box<GastoModel> _gastoBox = Hive.box<GastoModel>('gastos');

  List<GastoModel> getAll() {
    return _gastoBox.values.toList();
  }

  Future<void> addGasto(GastoModel gasto) async {
    await _gastoBox.add(gasto);
  }

  Future<void> deleteGasto(int index) async {
    await _gastoBox.deleteAt(index);
  }

  Future<void> updateGasto(int index, GastoModel gasto) async {
    await _gastoBox.putAt(index, gasto);
  }
}
