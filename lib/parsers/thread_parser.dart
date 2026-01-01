import '../models/post.dart';

abstract class ThreadParser {
  List<Post> parse(String html);
}
