// Lab 11 — Offline-First Notes & Settings Vault
// Author: Aidana Yerkengazina (Айдана Еркенгазина)

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note_item.dart';

/// Thin wrapper around SharedPreferences that owns all storage keys.
class StorageService {
  static const String themeKey = 'app_theme_dark_mode';
  static const String usernameKey = 'user_display_name';
  static const String notesKey = 'saved_notes_list';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Must be awaited in main() BEFORE runApp().
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // ---- 1. Theme (bool) ----
  bool loadDarkMode() => _prefs.getBool(themeKey) ?? false;

  Future<void> saveDarkMode(bool value) => _prefs.setBool(themeKey, value);

  // ---- 2. Username (String) ----
  String loadUsername() => _prefs.getString(usernameKey) ?? 'Guest User';

  Future<void> saveUsername(String name) => _prefs.setString(usernameKey, name);

  // ---- 3. Notes (List<NoteItem> <-> JSON String) ----
  List<NoteItem> loadNotes() {
    final String? raw = _prefs.getString(notesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => NoteItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return []; // corrupted data -> start fresh instead of crashing
    }
  }

  Future<void> saveNotes(List<NoteItem> notes) {
    final String encoded = jsonEncode(notes.map((n) => n.toJson()).toList());
    return _prefs.setString(notesKey, encoded);
  }
}
