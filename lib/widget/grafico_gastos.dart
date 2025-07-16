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
      porCategoria[gasto.categoria] =
          (porCategoria[gasto.categoria] ?? 0) + gasto.valor;
    }

    final total = porCategoria.values.fold(0.0, (sum, item) => sum + item);

    if (total == 0) {
      return const Center(child: Text('Sem dados para exibir o gráfico'));
    }

    // Tons de rosa (pode ser expandido se houver muitas categorias)
    final List<Color> tonsDeRosa = [
      const Color(0xFFF8BBD0),
      const Color(0xFFF48FB1),
      const Color(0xFFF06292),
      const Color(0xFFEC407A),
      const Color(0xFFD81B60),
      const Color(0xFFC2185B),
      const Color(0xFFAD1457),
    ];

    final categorias = porCategoria.entries.toList();

    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 30,
        sections: List.generate(categorias.length, (i) {
          final categoria = categorias[i];
          final percent = (categoria.value / total * 100).toStringAsFixed(1);

          return PieChartSectionData(
            color: tonsDeRosa[i % tonsDeRosa.length],
            value: categoria.value,
            title: '${categoria.key} ($percent%)',
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
      ),
    );
  }
}
