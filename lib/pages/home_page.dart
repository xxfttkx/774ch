import 'package:ch774/pages/settings_page.dart';
import 'package:ch774/viewmodels/settings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:ch774/pages/result_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: 'クルスタ');
  }

  void _search(String? keyword) {
    final query = keyword ?? controller.text.trim();
    if (query.isEmpty) return;
    final settingsViewModel = context.read<SettingsViewModel>();

    settingsViewModel.addSearchHistory(query); // 保存到历史

    final url = 'https://find.5ch.net/search?q=$query';
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultPage(url: url)),
    );
  }

  void _confirmDelete(String keyword) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete search history?'),
        content: Text('Remove "$keyword" from history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SettingsViewModel>().removeSearchHistory(keyword);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = context.watch<SettingsViewModel>();
    final colorScheme = ColorScheme.fromSeed(
      seedColor: settingsViewModel.color,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('5ch Aggregator')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Search keyword',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: _search,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _search(null),
                    child: const Text('Search'),
                  ),
                ),
                const SizedBox(height: 12),
                // 搜索历史
                if (settingsViewModel.searchHistory.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search History:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground, // 适应主题
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 8,
                        runSpacing: 8,
                        children: settingsViewModel.searchHistory.map((
                          keyword,
                        ) {
                          return Material(
                            color: colorScheme.secondaryContainer, // 替代固定灰色
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _search(keyword),
                              onLongPress: () {
                                _confirmDelete(keyword);
                              },
                              splashColor: colorScheme.primary.withValues(
                                alpha: 0.3,
                              ), // 使用主题主色
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  keyword,
                                  style: TextStyle(
                                    color:
                                        colorScheme.onSurfaceVariant, // 文字适配主题
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
              child: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
    );
  }
}
