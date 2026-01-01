import 'package:ch774/models/post.dart';
import 'package:ch774/parsers/fgo_parser.dart';
import 'package:ch774/parsers/kurusuta_parser.dart';
import 'package:ch774/services/thread_fetcher.dart';
import 'package:ch774/widgets/post_item.dart';
import 'package:flutter/material.dart';

class ThreadPage extends StatefulWidget {
  final String url;
  const ThreadPage({super.key, required this.url});

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  bool loading = true;
  bool reverse = true;
  final fetcher = ThreadFetcher();
  final parsers = [FGOParser(), KurusutaParser()];

  List<Post> replies = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    for (var parser in parsers) {
      try {
        final html = await fetcher.fetch(widget.url);
        final posts = parser.parse(html);
        if (posts.isNotEmpty) {
          if (!mounted) return;
          setState(() {
            replies = posts;
            loading = false;
          });
          return;
        }
      } catch (e) {
        // Continue to the next parser
      }
    }
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
