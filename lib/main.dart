import 'package:ch774/viewmodels/settings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsViewModel = SettingsViewModel();
  await settingsViewModel.load();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: settingsViewModel)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = context.watch<SettingsViewModel>();

    return MaterialApp(
      title: '774ch',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: settingsViewModel.color),
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'NotoSansJP',
          fontSizeFactor: settingsViewModel.fontSizeFactor,
        ),
      ),
      locale: settingsViewModel.locale,
      home: const HomePage(),
    );
  }
}
