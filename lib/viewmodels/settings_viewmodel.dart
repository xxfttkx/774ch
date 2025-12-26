import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  late final SharedPreferences _prefs;

  Locale _locale = const Locale('en');
  bool _isDark = false;
  int _colorIndex = 0;
  double _fontSizeFactor = 1.0;
  List<String> _searchHistory = [];

  Locale get locale => _locale;
  static const List<Color> presetColors = [
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.purple,
  ];
  bool get isDark => _isDark;
  Color get color => presetColors[_colorIndex];
  double get fontSizeFactor => _fontSizeFactor;
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final code = _prefs.getString('locale_code') ?? 'en';
    _locale = Locale(code);
    _isDark = _prefs.getBool('theme_dark') ?? false;
    _colorIndex = _prefs.getInt('theme_color_index') ?? 0;
    _fontSizeFactor = _prefs.getDouble('font_size_factor') ?? 1.0;
    _searchHistory = _prefs.getStringList('search_history') ?? [];
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString('locale_code', locale.languageCode);
    _locale = locale;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool('theme_dark', value);
    _isDark = value;
    notifyListeners();
  }

  Future<void> setColorIndex(int index) async {
    await _prefs.setInt('theme_color_index', index);
    _colorIndex = index;
    notifyListeners();
  }

  Future<void> setFontSizeFactor(double value) async {
    _fontSizeFactor = value;
    await _prefs.setDouble('font_size_factor', value);
    notifyListeners();
  }

  Future<void> addSearchHistory(String keyword) async {
    keyword = keyword.trim();
    if (keyword.isEmpty) return;

    _searchHistory.remove(keyword); // 避免重复
    _searchHistory.insert(0, keyword); // 最新的在最前面
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10); // 限制长度
    }
    await _prefs.setStringList('search_history', _searchHistory);
    notifyListeners();
  }

  void removeSearchHistory(String keyword) {
    _searchHistory.remove(keyword);
    notifyListeners();
  }
}
