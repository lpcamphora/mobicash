import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/gasto_model.dart';
import '../../model/settings_model.dart';
import '../../service/settings_service.dart';
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

  Key _dropdownKey = UniqueKey();
  Key _dropdownCartaoKey = UniqueKey();

  late SettingsModel _settings;
  bool _carregando = true;
  final _settingsService = SettingsService();

  List<String> get _categoriasAtuais =>
      _tipoSelecionado == TipoLancamento.despesa
          ? _settings.categoriasDespesas
          : _settings.categoriasReceitas;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final dados = await _settingsService.carregarOuCriarPadrao();
    setState(() {
      _settings = dados;
      _carregando = false;
    });
  }

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

  void _mostrarPopupNovaCategoria() {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Nova categoria'),
            content: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Nome da categoria'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  final nova = _controller.text.trim();
                  if (nova.isNotEmpty && !_categoriasAtuais.contains(nova)) {
                    setState(() {
                      _categoriasAtuais.add(nova);
                      _categoriaSelecionada = nova;
                      _dropdownKey = UniqueKey();
                    });
                    await _settingsService.salvar(_settings);
                  }
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _mostrarPopupEditarOuExcluirCategoria(String categoria) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('O que deseja fazer?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _mostrarPopupEdicaoCategoria(categoria);
                },
                child: const Text('Editar'),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _categoriasAtuais.remove(categoria);
                    if (_categoriaSelecionada == categoria) {
                      _categoriaSelecionada = null;
                    }
                    _dropdownKey = UniqueKey();
                  });
                  await _settingsService.salvar(_settings);
                  Navigator.pop(context);
                },
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }

  void _mostrarPopupEdicaoCategoria(String categoriaAntiga) {
    final controller = TextEditingController(text: categoriaAntiga);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Editar categoria'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Novo nome da categoria',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  final novo = controller.text.trim();
                  if (novo.isNotEmpty && !_categoriasAtuais.contains(novo)) {
                    setState(() {
                      final index = _categoriasAtuais.indexOf(categoriaAntiga);
                      _categoriasAtuais[index] = novo;
                      if (_categoriaSelecionada == categoriaAntiga) {
                        _categoriaSelecionada = novo;
                      }
                      _dropdownKey = UniqueKey();
                    });
                    await _settingsService.salvar(_settings);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
    );
  }

  void _mostrarPopupNovoCartao() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Novo cartão'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Nome do cartão'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  final novo = controller.text.trim();
                  if (novo.isNotEmpty && !_settings.cartoes.contains(novo)) {
                    setState(() {
                      _settings.cartoes.add(novo);
                      _cartaoSelecionado = novo;
                      _dropdownCartaoKey = UniqueKey();
                    });
                    await _settingsService.salvar(_settings);
                  }
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _mostrarPopupEditarOuExcluirCartao(String cartao) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('O que deseja fazer?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _mostrarPopupEdicaoCartao(cartao);
                },
                child: const Text('Editar'),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _settings.cartoes.remove(cartao);
                    if (_cartaoSelecionado == cartao) {
                      _cartaoSelecionado = null;
                    }
                    _dropdownCartaoKey = UniqueKey();
                  });
                  await _settingsService.salvar(_settings);
                  Navigator.pop(context);
                },
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }

  void _mostrarPopupEdicaoCartao(String cartaoAntigo) {
    final controller = TextEditingController(text: cartaoAntigo);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Editar cartão'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Novo nome do cartão',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  final novo = controller.text.trim();
                  if (novo.isNotEmpty && !_settings.cartoes.contains(novo)) {
                    setState(() {
                      final index = _settings.cartoes.indexOf(cartaoAntigo);
                      _settings.cartoes[index] = novo;
                      if (_cartaoSelecionado == cartaoAntigo) {
                        _cartaoSelecionado = novo;
                      }
                      _dropdownCartaoKey = UniqueKey();
                    });
                    await _settingsService.salvar(_settings);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
    );
  }

  void _salvar() {
    if (_formKey.currentState!.validate() &&
        _categoriaSelecionada != null &&
        _cartaoSelecionado != null) {
      final gasto = GastoModel(
        descricao: _descricaoController.text,
        valor: double.parse(_valorController.text.replaceAll(',', '.')),
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
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio<TipoLancamento>(
                        value: TipoLancamento.despesa,
                        groupValue: _tipoSelecionado,
                        onChanged: (value) {
                          setState(() {
                            _tipoSelecionado = value!;
                            _categoriaSelecionada = null;
                            _dropdownKey = UniqueKey();
                          });
                        },
                      ),
                      const Text('Despesas'),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Row(
                    children: [
                      Radio<TipoLancamento>(
                        value: TipoLancamento.receita,
                        groupValue: _tipoSelecionado,
                        onChanged: (value) {
                          setState(() {
                            _tipoSelecionado = value!;
                            _categoriaSelecionada = null;
                            _dropdownKey = UniqueKey();
                          });
                        },
                      ),
                      const Text('Receitas'),
                    ],
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
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe a descrição'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  hintText: 'Valor',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [],
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o valor'
                            : null,
              ),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: _dropdownKey,
                decoration: const InputDecoration(
                  hintText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                value: _categoriaSelecionada,
                items: [
                  ..._categoriasAtuais.map(
                    (cat) => DropdownMenuItem(
                      value: cat,
                      child: GestureDetector(
                        onLongPress: () {
                          Future.delayed(
                            const Duration(milliseconds: 0),
                            () => _mostrarPopupEditarOuExcluirCategoria(cat),
                          );
                        },
                        child: Text(cat),
                      ),
                    ),
                  ),
                  const DropdownMenuItem(
                    value: 'nova_categoria',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Icon(Icons.add_circle_outline, size: 22)],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == 'nova_categoria') {
                    _mostrarPopupNovaCategoria();
                  } else {
                    setState(() => _categoriaSelecionada = value);
                  }
                },
                validator:
                    (value) =>
                        value == null || value == 'nova_categoria'
                            ? 'Escolha uma categoria'
                            : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: _dropdownCartaoKey,
                decoration: const InputDecoration(
                  hintText: 'Cartão',
                  border: OutlineInputBorder(),
                ),
                value: _cartaoSelecionado,
                items: [
                  ..._settings.cartoes.map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: GestureDetector(
                        onLongPress: () {
                          Future.delayed(
                            const Duration(milliseconds: 0),
                            () => _mostrarPopupEditarOuExcluirCartao(c),
                          );
                        },
                        child: Text(c),
                      ),
                    ),
                  ),
                  const DropdownMenuItem(
                    value: 'novo_cartao',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Icon(Icons.add_circle_outline, size: 22)],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == 'novo_cartao') {
                    _mostrarPopupNovoCartao();
                  } else {
                    setState(() => _cartaoSelecionado = value);
                  }
                },
                validator:
                    (value) =>
                        value == null || value == 'novo_cartao'
                            ? 'Escolha um cartão'
                            : null,
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
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
