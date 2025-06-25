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
        _categoriaSelecionada != nul_
