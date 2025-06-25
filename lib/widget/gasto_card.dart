import 'package:flutter/material.dart';
import '../model/gasto_model.dart';
import 'package:intl/intl.dart';

class GastoCard extends StatelessWidget {
  final GastoModel gasto;
  final VoidCallback onDelete;

  const GastoCard({
    super.key,
    required this.gasto,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dataFormatada = DateFormat('dd/MM/yyyy').format(gasto.data);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.attach_money_rounded, color: Colors.green),
        title: Text(gasto.descricao),
        subtitle: Text('${gasto.categoria} • $dataFormatada'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatter.format(gasto.valor),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
