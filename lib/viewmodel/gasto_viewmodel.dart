import 'package:flutter/material.dart';
import '../model/gasto_model.dart';
import '../service/gasto_service.dart';

class GastoViewModel extends ChangeNotifier {
  final GastoService _gastoService = GastoService();

  List<GastoModel> _gastos = [];

  List<GastoModel> get gastos => _gastos;

  // Carrega todos os gastos salvos no Hive
  void carregarGastos() {
    _gastos = _gastoService.getAll();
    notifyListeners();
  }

  // Adiciona um novo gasto
  Future<void> adicionarGasto(GastoModel gasto) async {
    await _gastoService.addGasto(gasto);
    carregarGastos(); // atualiza a lista
  }

  // Remove um gasto pelo índice
  Future<void> removerGasto(int index) async {
    await _gastoService.deleteGasto(index);
    carregarGastos();
  }

  // Atualiza um gasto existente
  Future<void> atualizarGasto(int index, GastoModel gasto) async {
    await _gastoService.updateGasto(index, gasto);
    carregarGastos();
  }

  // Total geral
  double get totalGastos {
    return _gastos.fold(0.0, (sum, item) => sum + item.valor);
  }
}
