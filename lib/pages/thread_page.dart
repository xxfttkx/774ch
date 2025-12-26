import 'package:ch774/widgets/post_item.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class ThreadPage extends StatefulWidget {
  final String url;
  const ThreadPage({super.key, required this.url});

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  bool loading = true;
  bool reverse = true;
  List<Map<String, String>> replies = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final res = await http.get(
      Uri.parse(widget.url),
      headers: {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"},
    );

    final bytes = res.bodyBytes;

    // 自动识别 + Shift-JIS 解码
    final decoded = await CharsetConverter.decode("shift_jis", bytes);

    final document = parse(decoded);

    final articles = document.querySelectorAll("article.clear.post");

    final List<Map<String, String>> temp = [];

    for (final art in articles) {
      final postId = art.attributes["data-id"]?.trim() ?? "";

      final header = art.querySelector("details.post-header");
      if (header == null) continue;

      final dateText = header.querySelector("span.date")?.text.trim() ?? "";
      final uidText = header.querySelector("span.uid")?.text.trim() ?? "";

      final content = art.querySelector("section.post-content");
      final bodyText = content?.text.trim() ?? "";

      temp.add({
        "post_id": postId,
        "date_text": dateText,
        "uid_text": uidText,
        "body_text": bodyText,
      });
    }

    if (!mounted) return;
    setState(() {
      replies = temp;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = reverse ? replies.reversed.toList() : replies;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thread"),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_vert),
            onPressed: () {
              setState(() {
                reverse = !reverse;
              });
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                return PostItem(post: list[i]);
              },
            ),
    );
  }
}
