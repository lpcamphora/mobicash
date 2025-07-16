import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/gasto_viewmodel.dart';
import '../../widget/grafico_gastos.dart';
import 'package:intl/intl.dart';


class ReportsView extends StatelessWidget {
  final DateTime mesSelecionado;

  const ReportsView({super.key, required this.mesSelecionado});

  @override
  Widget build(BuildContext context) {
    final gastos = Provider.of<GastoViewModel>(context)
        .gastos
        .where((g) =>
            g.tipo == TipoLancamento.despesa &&
            g.data.month == mesSelecionado.month &&
            g.data.year == mesSelecionado.year)
        .toList();

    final mesStr = toBeginningOfSentenceCase(
      DateFormat.MMMM('pt_BR').format(mesSelecionado),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Despesas - $mesStr',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 300, child: GraficoGastos(gastos: gastos)),
        ],
      ),
    );
  }
}

