import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/gasto_viewmodel.dart';
import '../../widget/grafico_gastos.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final gastos = Provider.of<GastoViewModel>(context).gastos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GraficoGastos(gastos: gastos),
      ),
    );
  }
}
