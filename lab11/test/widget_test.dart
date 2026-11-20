// Lab 11 — tests for persistence logic
// Author: Aidana Yerkengazina (Айдана Еркенгазина)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lab11/main.dart';
import 'package:lab11/models/note_item.dart';
import 'package:lab11/services/storage_service.dart';

void main() {
  test('NoteItem toJson/fromJson round-trip', () {
    const note = NoteItem(
        id: '1', title: 'Buy milk', dateText: '20.11.2026', isCompleted: true);
    final copy = NoteItem.fromJson(note.toJson());
    expect(copy.id, '1');
    expect(copy.title, 'Buy milk');
    expect(copy.dateText, '20.11.2026');
    expect(copy.isCompleted, true);
  });

  test('defaults when storage is empty', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.init();
    expect(storage.loadDarkMode(), false);
    expect(storage.loadUsername(), 'Guest User');
    expect(storage.loadNotes(), isEmpty);
  });

  testWidgets('state survives a "cold restart"', (tester) async {
    SharedPreferences.setMockInitialValues({});
    var storage = await StorageService.init();
    await tester.pumpWidget(VaultApp(storage: storage, initialDarkMode: false));
    expect(find.text('Hello, Guest User!'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('usernameField')), 'Aidana');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    for (final t in ['First note', 'Second note']) {
      await tester.enterText(find.byKey(const Key('noteField')), t);
      await tester.tap(find.byTooltip('Add note'));
      await tester.pump();
    }
    await tester.tap(find.byKey(const Key('darkModeSwitch')));
    await tester.pumpAndSettle();

    // "Kill" the app and rebuild from disk, exactly like main() does.
    await tester.pumpWidget(const SizedBox());
    storage = await StorageService.init();
    await tester.pumpWidget(
        VaultApp(storage: storage, initialDarkMode: storage.loadDarkMode()));
    await tester.pumpAndSettle();

    expect(storage.loadDarkMode(), true);
    expect(find.text('Hello, Aidana!'), findsOneWidget);
    expect(find.text('Second note'), findsOneWidget); // newest first
    expect(storage.loadNotes().first.title, 'Second note');
    expect(storage.loadNotes().length, 2);
  });
}
