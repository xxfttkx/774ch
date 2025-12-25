import 'package:ch774/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:ch774/pages/result_page.dart';

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

  void _search() {
    final encoded = controller.text.trim();
    final url = 'https://find.5ch.net/search?q=$encoded';

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultPage(url: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('5ch Aggregator')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Search keyword',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _search,
                    child: const Text('Search'),
                  ),
                ),
              ],
            ),
          ),
          // 左下角的设置按钮
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
