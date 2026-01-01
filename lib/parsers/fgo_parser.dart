import 'package:html/parser.dart' as html;
import '../models/post.dart';
import 'thread_parser.dart';

class FGOParser implements ThreadParser {
  @override
  List<Post> parse(String htmlText) {
    final document = html.parse(htmlText);
    final nodes = document.querySelectorAll('.clear.post');

    final result = <Post>[];

    for (final node in nodes) {
      final id = node.attributes['data-id'] ?? '';

      final header = node.querySelector('.post-header');
      if (header == null) continue;

      final date = header.querySelector('.date')?.text.trim() ?? '';
      final uid = header.querySelector('.uid')?.text.trim() ?? '';
      final body = node.querySelector('.post-content')?.text.trim() ?? '';

      result.add(Post(id: id, date: date, uid: uid, body: body));
    }

    return result;
  }
}
