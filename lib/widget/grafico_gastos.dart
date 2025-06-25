import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/gasto_model.dart';
import 'dart:math';

class GraficoGastos extends StatelessWidget {
  final List<GastoModel> gastos;

  const GraficoGastos({super.key, required this.gastos});

  @override
  Widget build(BuildContext context) {
    final Map<String, double> porCategoria = {};

    for (var gasto in gastos) {
      porCategoria[gasto.categoria] = (porCategoria[gasto.categoria] ?? 0) + gasto.valor;
    }

    final total = porCategoria.values.fold(0.0, (sum, item) => sum + item);

    if (total == 0) {
      return const Center(child: Text('Sem dados para exibir o gráfico'));
    }

    return PieChart(
      PieChartData(
        sections: porCategoria.entries.map((entry) {
          final percent = (entry.value / total * 100).toStringAsFixed(1);
          return PieChartSectionData(
            title: '${entry.key} ($percent%)',
            value: entry.value,
            radius: 100,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          );
        }).toList(),
        sectionsSpace: 4,
        centerSpaceRadius: 30,
      ),
    );
  }
}
