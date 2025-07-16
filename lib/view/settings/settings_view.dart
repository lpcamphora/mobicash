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
              Provider.of<GastoViewModel>(context, listen: false).carregarGastos();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todos os dados foram apagados'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Apagar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            children: [
              const Center(
                child: Text(
                  'Configurações',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Histórico'),
                subtitle: const Text('Ver lançamentos anteriores'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Histórico (em desenvolvimento)')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Tema'),
                subtitle: const Text('Claro / Escuro / Sistema'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Alteração de tema (em breve)')),
                  );
                },
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('Versão do App'),
                subtitle: Text('MobiCash v1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Apagar todos os dados'),
                subtitle: const Text('Remove todos os lançamentos do app'),
                onTap: () => _confirmarReset(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
