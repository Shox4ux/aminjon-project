import 'dart:convert';
import 'dart:js_interop';

@JS('localStorage.getItem')
external String? _getItem(String key);

@JS('localStorage.setItem')
external void _setItem(String key, String value);

@JS('localStorage.removeItem')
external void _removeItem(String key);

class FormDraft {
  static void save(String key, Map<String, dynamic> data) {
    try {
      _setItem(key, jsonEncode(data));
    } catch (_) {}
  }

  static Map<String, dynamic>? load(String key) {
    try {
      final raw = _getItem(key);
      if (raw == null) return null;
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static void clear(String key) {
    try {
      _removeItem(key);
    } catch (_) {}
  }
}
