import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/gasto_model.dart';
import '../../viewmodel/gasto_viewmodel.dart' show GastoViewModel;
import '../../routes/app_routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GastoViewModel>(context);
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    final receitas =
        viewModel.gastos
            .where((g) => g.tipo == TipoLancamento.receita)
            .toList();
    final despesas =
        viewModel.gastos
            .where((g) => g.tipo == TipoLancamento.despesa)
            .toList();

    final totalReceitas = receitas.fold(0.0, (sum, g) => sum + g.valor);
    final totalDespesas = despesas.fold(0.0, (sum, g) => sum + g.valor);
    final saldo = totalReceitas - totalDespesas;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            const SizedBox(height: 32),

            Container(
              constraints: const BoxConstraints(maxHeight: 120),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: _buildResumoComLista(
                  label: 'Total Receita',
                  valor: formatter.format(totalReceitas),
                  gastos: receitas,
                  formatter: formatter,
                ),
              ),
            ),
            const SizedBox(height: 24),

            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Despesas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            formatter.format(totalDespesas),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.remove_circle_outline, size: 18),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: despesas.length,
                      itemBuilder: (context, index) {
                        final g = despesas[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(g.descricao),
                            Text(formatter.format(g.valor)),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saldo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  formatter.format(saldo),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isMenuOpen) ...[
              _menuItem(Icons.add, 'Novo registro', () {
                Navigator.pushNamed(context, AppRoutes.newEntry);
              }),
              const SizedBox(height: 8),
              _menuItem(Icons.insert_chart, 'Relatórios', () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abrir relatórios')),
                );
              }),
              const SizedBox(height: 8),
              _menuItem(Icons.settings, 'Configurações', () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abrir configurações')),
                );
              }),
              const SizedBox(height: 16),
            ],
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  isMenuOpen = !isMenuOpen;
                });
              },
              backgroundColor: Colors.grey.shade300,
              child: Icon(
                isMenuOpen ? Icons.close : Icons.add,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoComLista({
    required String label,
    required String valor,
    required List gastos,
    required NumberFormat formatter,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  valor,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.remove_circle_outline, size: 18),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...gastos.map<Widget>((g) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(g.descricao), Text(formatter.format(g.valor))],
          );
        }).toList(),
      ],
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: Colors.grey.shade300,
          child: Text(label),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          heroTag: label,
          mini: true,
          backgroundColor: Colors.black,
          onPressed: onPressed,
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ],
    );
  }
}
