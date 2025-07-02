import 'package:flutter/material.dart';
import '../model/gasto_model.dart';
import '../service/gasto_service.dart';

enum TipoLancamento { receita, despesa }

class GastoViewModel extends ChangeNotifier {
  final GastoService _gastoService = GastoService();

  List<GastoModel> _gastos = [];

  List<GastoModel> get gastos => _gastos;

  void carregarGastos() {
    _gastos = _gastoService.getAll();
    notifyListeners();
  }

  Future<void> adicionarGasto(GastoModel gasto) async {
    await _gastoService.addGasto(gasto);
    carregarGastos();
  }

  Future<void> removerGasto(int index) async {
    await _gastoService.deleteGasto(index);
    carregarGastos();
  }

  // 🔹 Getters que a HomeView usa
  double get totalReceitas => _gastos
      .where((g) => g.tipo == TipoLancamento.receita)
      .fold(0.0, (sum, g) => sum + g.valor);

  double get totalDespesas => _gastos
      .where((g) => g.tipo == TipoLancamento.despesa)
      .fold(0.0, (sum, g) => sum + g.valor);

  double get saldo => totalReceitas - totalDespesas;
}
