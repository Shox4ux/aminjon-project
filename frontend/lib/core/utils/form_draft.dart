import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class FormDraft {
  static void save(String key, Map<String, dynamic> data) {
    try {
      html.window.localStorage[key] = jsonEncode(data);
    } catch (_) {}
  }

  static Map<String, dynamic>? load(String key) {
    try {
      final raw = html.window.localStorage[key];
      if (raw == null) return null;
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static void clear(String key) {
    try {
      html.window.localStorage.remove(key);
    } catch (_) {}
  }
}
