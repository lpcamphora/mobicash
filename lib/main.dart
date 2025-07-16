import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobicash/database/hive_config.dart';
import 'package:mobicash/viewmodel/gasto_viewmodel.dart';
import 'package:mobicash/model/settings_model.dart';
import 'package:mobicash/routes/app_routes.dart';

import 'package:mobicash/view/splash/splash_view.dart';
import 'package:mobicash/view/home/home_view.dart';
import 'package:mobicash/view/new_entry/new_entry_view.dart';
import 'package:mobicash/view/settings/settings_view.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initializeDateFormatting('pt_BR', null); // ✅ importante

  Hive.registerAdapter(SettingsModelAdapter());
  await initHive();

  runApp(const MobiCashApp());
}

class MobiCashApp extends StatelessWidget {
  const MobiCashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GastoViewModel()..carregarGastos(),
        ),
      ],
      child: MaterialApp(
        title: 'MobiCash',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashView(),
          AppRoutes.home: (context) => const HomeView(),
          AppRoutes.newEntry: (context) => const NewEntryView(),
          AppRoutes.settings: (context) => const SettingsView(),
        },
      ),
    );
  }
}
