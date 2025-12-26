import 'package:flutter/material.dart';
import 'package:ch774/pages/thread_page.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class ResultPage extends StatefulWidget {
  final String url;
  const ResultPage({super.key, required this.url});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool loading = true;
  List<Map<String, String>> results = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final res = await http.get(
      Uri.parse(widget.url),
      headers: {"User-Agent": "Mozilla/5.0"},
    );

    final document = parse(res.body);

    final items = document.querySelectorAll("div.list > div.list_line");

    final List<Map<String, String>> temp = [];

    for (final item in items) {
      final link = item.querySelector("a.list_line_link");
      final info = item.querySelectorAll("div.list_line_info_container");

      if (link == null || info.length < 3) continue;

      final title =
          link.querySelector(".list_line_link_title")?.text.trim() ?? "";
      final url = link.attributes["href"] ?? "";

      final time = info[1].text.trim();
      final replies = info[2].text.trim();

      temp.add({"title": title, "url": url, "time": time, "replies": replies});
    }

    if (!mounted) return;
    setState(() {
      results = temp;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Result")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: results.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final item = results[i];
                return ListTile(
                  title: Text(item["title"]!),
                  subtitle: Text("${item["time"]}  |  ${item["replies"]}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ThreadPage(url: item["url"]!),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
