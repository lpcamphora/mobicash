import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/gasto_model.dart';
import '../../viewmodel/gasto_viewmodel.dart';
import '../../routes/app_routes.dart';

class NewEntryView extends StatefulWidget {
  const NewEntryView({super.key});

  @override
  State<NewEntryView> createState() => _NewEntryViewState();
}

class _NewEntryViewState extends State<NewEntryView> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  String? _categoriaSelecionada;
  String? _cartaoSelecionado;
  DateTime _dataSelecionada = DateTime.now();

  final List<String> _categorias = ['Alimentação', 'Transporte', 'Lazer', 'Saúde'];
  final List<String> _cartoes = ['Débito Itaú', 'Crédito Nubank', 'Pix', 'Dinheiro'];

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (dataEscolhida != null && dataEscolhida != _dataSelecionada) {
      setState(() {
        _dataSelecionada = dataEscolhida;
      });
    }
  }

  void _salvar() {
    if (_formKey.currentState!.validate() &&
        _categoriaSelecionada != null &&
        _cartaoSelecionado != null) {
      final gasto = GastoModel(
        descricao: _descricaoController.text,
        valor: double.parse(_valorController.text),
        data: _dataSelecionada,
        categoria: _categoriaSelecionada!,
        cartao: _cartaoSelecionado!,
      );

      Provider.of<GastoViewModel>(context, listen: false).adicionarGasto(gasto);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Novo Gasto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a descrição' : null,
              ),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o valor' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Categoria'),
                value: _categoriaSelecionada,
                items: _categorias
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _categoriaSelecionada = value),
                validator: (value) => value == null ? 'Escolha uma categoria' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Cartão'),
                value: _cartaoSelecionado,
                items: _cartoes
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => setState(() => _cartaoSelecionado = value),
                validator: (value) => value == null ? 'Escolha um cartão' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data'),
                subtitle: Text(formatter.format(_dataSelecionada)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selecionarData,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Salvar Gasto'),
                onPressed: _salvar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
