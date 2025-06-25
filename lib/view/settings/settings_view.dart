import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../model/gasto_model.dart';
import '../../viewmodel/gasto_viewmodel.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  void _confirmarReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Apagar todos os dados?'),
        content: const Text('Essa ação é irreversível. Deseja continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final box = Hive.box<GastoModel>('gastos');
              box.clear();

              // Atualiza a UI com os dados zerados
              Provider.of<GastoViewModel>(context, listen: false).carregarGastos();

              Navigator.pop(context); // Fecha o diálogo

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todos os dados foram apagados'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Apagar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Sobre o App'),
            subtitle: Text('MobiCash v1.0.0\nControle financeiro pessoal'),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Apagar todos os dados'),
            subtitle: const Text('Remove todos os gastos do app'),
            onTap: () => _confirmarReset(context),
          ),
        ],
      ),
    );
  }
}
