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
    final vm = context.read<SettingsViewModel>();

    vm.addSearchHistory(query); // 保存到历史

    final url = 'https://find.5ch.net/search?q=$query';
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultPage(url: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();
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
                if (vm.searchHistory.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Search History:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        alignment: WrapAlignment.start, // 左对齐
                        spacing: 8, // 水平间距
                        runSpacing: 8, // 换行间距
                        children: vm.searchHistory.map((keyword) {
                          return Material(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _search(keyword),
                              splashColor: Colors.blue.withAlpha(
                                (0.3 * 255).round(),
                              ), // 涟漪颜色
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(keyword),
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
