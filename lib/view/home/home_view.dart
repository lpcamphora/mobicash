import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/gasto_viewmodel.dart';
import '../../widget/gasto_card.dart';
import '../../routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GastoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MobiCash'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.reports),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: viewModel.gastos.isEmpty
