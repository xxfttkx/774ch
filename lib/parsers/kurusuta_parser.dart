import 'package:html/parser.dart' as html;
import '../models/post.dart';
import 'thread_parser.dart';

class KurusutaParser implements ThreadParser {
  @override
  List<Post> parse(String htmlText) {
    final document = html.parse(htmlText);
    final nodes = document.querySelectorAll("article.clear.post");

    final result = <Post>[];

    for (final art in nodes) {
      final id = art.attributes["data-id"]?.trim() ?? "";

      final header = art.querySelector("details.post-header");
      if (header == null) continue;

      final date = header.querySelector("span.date")?.text.trim() ?? "";
      final uid = header.querySelector("span.uid")?.text.trim() ?? "";
      final content = art.querySelector("section.post-content");
      final body = content?.text.trim() ?? "";

      result.add(Post(id: id, date: date, uid: uid, body: body));
    }

    return result;
  }
}
