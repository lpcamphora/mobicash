import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/gasto_model.dart';
import '../../viewmodel/gasto_viewmodel.dart' show GastoViewModel;

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
  TipoLancamento _tipoSelecionado = TipoLancamento.despesa;

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
    if (dataEscolhida != null) {
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
        tipo: _tipoSelecionado,
      );

      Provider.of<GastoViewModel>(context, listen: false).adicionarGasto(gasto);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Novo Registro',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Botões de tipo: Despesas | Receitas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    label: const Text('Despesas'),
                    selected: _tipoSelecionado == TipoLancamento.despesa,
                    onSelected: (_) {
                      setState(() => _tipoSelecionado = TipoLancamento.despesa);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Receitas'),
                    selected: _tipoSelecionado == TipoLancamento.receita,
                    onSelected: (_) {
                      setState(() => _tipoSelecionado = TipoLancamento.receita);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  hintText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  hintText: 'Valor',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o valor' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                value: _categoriaSelecionada,
                items: _categorias
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _categoriaSelecionada = value),
                validator: (value) => value == null ? 'Escolha uma categoria' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Cartão',
                  border: OutlineInputBorder(),
                ),
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
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _salvar,
                  child: const Text('SALVAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
