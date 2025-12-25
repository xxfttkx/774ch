import 'package:ch774/viewmodels/settings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() async {
  final settingsViewModel = SettingsViewModel();
  await settingsViewModel.load();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => settingsViewModel)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = context.watch<SettingsViewModel>();
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: '774ch',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: settingsViewModel.color,
            // ??const Color.fromARGB(255, 21, 255, 25),
          ),
          textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'NotoSansSC',
            fontSizeFactor: settingsViewModel.fontSizeFactor, // 缩放字体大小
          ),
        ),
        locale: settingsViewModel.locale, // 如果你支持动态切换语言
        home: const HomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}
