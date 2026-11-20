# Lab 11 — Offline-First Notes & Settings Vault

**Author:** Aidana Yerkengazina (Айдана Еркенгазина)

A single-screen Flutter app that keeps its entire state on disk with `shared_preferences: ^2.2.2`.

## Features

| # | Requirement | Where |
|---|-------------|-------|
| 1 | Dark Mode switch, saved under `app_theme_dark_mode`, pre-loaded in `main()` before `runApp()` (no white flash) | `lib/main.dart` → `main()`, `_VaultAppState._setDarkMode` |
| 2 | Username field + Save, stored under `user_display_name`, header falls back to `Guest User` | `_VaultScreenState._saveUsername`, `StorageService.loadUsername` |
| 3 | `NoteItem` (id, title, dateText, isCompleted) with `toJson()` / `fromJson()`; add (prepend), toggle, delete, each re-saves the JSON list | `lib/models/note_item.dart`, `lib/services/storage_service.dart` |
| 4 | Cold-restart test | see below + `test/widget_test.dart` |

## How the data flows

```
List<NoteItem> → map(toJson) → jsonEncode → String → setString('saved_notes_list')
getString('saved_notes_list') → jsonDecode → List<dynamic> → map(NoteItem.fromJson) → List<NoteItem>
```

## Run

```bash
flutter pub get
flutter run
flutter test
```

## Cold Restart Test

1. Enter a username and press **Save**.
2. Add 2 notes, tick one of them.
3. Turn **Dark Mode** on.
4. Force-kill the app (swipe away in the app switcher / Cmd+Q on the simulator).
5. Open it again: dark theme from the first frame, name in the header, both notes with their checkbox state.

## Defense notes

- **Why `WidgetsFlutterBinding.ensureInitialized()`?** `SharedPreferences.getInstance()` uses a platform channel, which needs the binding before `runApp()`. Reading the theme first means the very first frame is already in the correct theme, so there is no flicker.
- **SharedPreferences vs Keychain/KeyStore:** SharedPreferences (Android XML file) / NSUserDefaults (iOS plist) is **plain, unencrypted** key-value storage inside the app sandbox — fine for theme, name, notes, but readable on a rooted/jailbroken device or from a backup. Passwords, tokens and API keys belong in the **iOS Keychain / Android KeyStore** (e.g. via `flutter_secure_storage`), which encrypts with hardware-backed keys.
- **Why JSON?** SharedPreferences only stores primitives (`bool`, `int`, `double`, `String`, `List<String>`), so a list of objects is serialized to one JSON string.
- **Limitations:** not for large data or queries — use SQLite/Hive/Isar for that.
