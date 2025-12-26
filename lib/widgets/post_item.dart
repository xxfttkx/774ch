import 'package:flutter/material.dart';

class PostItem extends StatefulWidget {
  final Map<String, String> post;
  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool showImages = false;
  final imageReg = RegExp(r'(https?:\/\/\S+\.(?:png|jpg|jpeg|gif|webp))');

  List<String> extractImages(String text) {
    return imageReg.allMatches(text).map((m) => m.group(0)!).toList();
  }

  @override
  Widget build(BuildContext context) {
    final body = widget.post["body_text"]!;
    final images = extractImages(body);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.post["post_id"]}  ${widget.post["date_text"]}  ${widget.post["uid_text"]}",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          SelectableText(body),

          if (images.isNotEmpty) ...[
            const SizedBox(height: 8),

            /// 👇 展开按钮
            InkWell(
              onTap: () => setState(() => showImages = !showImages),
              child: Text(
                showImages
                    ? "▲ Hide images"
                    : "🖼 Show images (${images.length})",
                style: const TextStyle(color: Colors.blue),
              ),
            ),

            const SizedBox(height: 6),

            if (showImages)
              Column(
                children: images.map((url) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        loadingBuilder: (c, w, p) {
                          if (p == null) return w;
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ],
      ),
    );
  }
}
