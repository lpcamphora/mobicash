import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodel/gasto_viewmodel.dart';
import '../../widget/gasto_card.dart';
import '../../routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GastoViewModel>(context);
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          // Cabeçalho do mês com setas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.chevron_left, color: Colors.black),
              SizedBox(width: 8),
              Text(
                'Junho',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.black),
            ],
          ),
          const SizedBox(height: 24),
          // Totais
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildResumoLinha(
                  label: 'Total Receita',
                  valor: formatter.format(viewModel.totalReceitas),
                  onAdd: () => Navigator.pushNamed(context, AppRoutes.newEntry),
                ),
                _buildResumoLinha(
                  label: 'Total Despesas',
                  valor: formatter.format(viewModel.totalDespesas),
                  onAdd: () => Navigator.pushNamed(context, AppRoutes.newEntry),
                ),
                _buildResumoLinha(
                  label: 'Saldo',
                  valor: formatter.format(viewModel.saldo),
                  onAdd: null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          // Lista de gastos
          Expanded(
            child: viewModel.gastos.isEmpty
                ? const Center(child: Text('Nenhum gasto cadastrado'))
                : ListView.builder(
                    itemCount: viewModel.gastos.length,
                    itemBuilder: (context, index) {
                      final gasto = viewModel.gastos[index];
                      return GastoCard(
                        gasto: gasto,
                        onDelete: () => viewModel.removerGasto(index),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.newEntry),
        backgroundColor: Colors.grey.shade300,
        elevation: 2,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  static Widget _buildResumoLinha({
    required String label,
    required String valor,
    VoidCallback? onAdd,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (onAdd != null)
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onAdd,
                  color: Colors.grey.shade600,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
