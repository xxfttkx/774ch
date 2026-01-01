import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';

class ThreadFetcher {
  Future<String> fetch(String url) async {
    final res = await http.get(
      Uri.parse(url),
      headers: {"User-Agent": "Mozilla/5.0"},
    );

    final bytes = res.bodyBytes;
    return await CharsetConverter.decode("shift_jis", bytes);
  }
}
