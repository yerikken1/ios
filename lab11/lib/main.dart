// Lab 11 — Offline-First Notes & Settings Vault
// Author: Aidana Yerkengazina (Айдана Еркенгазина)

import 'package:flutter/material.dart';

import 'models/note_item.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  // Required so plugins (SharedPreferences) can talk to the platform
  // before the first frame is drawn.
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-load everything from disk BEFORE runApp() -> no white flash
  // when the app is opened in dark mode.
  final storage = await StorageService.init();
  final bool isDark = storage.loadDarkMode();

  runApp(VaultApp(storage: storage, initialDarkMode: isDark));
}

class VaultApp extends StatefulWidget {
  final StorageService storage;
  final bool initialDarkMode;

  const VaultApp({
    super.key,
    required this.storage,
    required this.initialDarkMode,
  });

  @override
  State<VaultApp> createState() => _VaultAppState();
}

class _VaultAppState extends State<VaultApp> {
  late bool _isDark = widget.initialDarkMode;

  static const Color _burgundy = Color(0xFF800020);

  Future<void> _setDarkMode(bool value) async {
    setState(() => _isDark = value);
    await widget.storage.saveDarkMode(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes & Settings Vault',
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _burgundy),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _burgundy,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: VaultScreen(
        storage: widget.storage,
        isDark: _isDark,
        onThemeChanged: _setDarkMode,
      ),
    );
  }
}

class VaultScreen extends StatefulWidget {
  final StorageService storage;
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const VaultScreen({
    super.key,
    required this.storage,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();

  late String _username;
  late List<NoteItem> _notes;

  @override
  void initState() {
    super.initState();
    // Auto-load persisted state on launch.
    _username = widget.storage.loadUsername();
    _notes = widget.storage.loadNotes();
    if (_username != 'Guest User') _nameController.text = _username;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // ---------- Username ----------
  Future<void> _saveUsername() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    FocusScope.of(context).unfocus();
    await widget.storage.saveUsername(name);
    if (!mounted) return;
    setState(() => _username = name);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved name: $name')),
    );
  }

  // ---------- Notes CRUD ----------
  String _formatDate(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  Future<void> _addNote() async {
    final title = _noteController.text.trim();
    if (title.isEmpty) return;
    final now = DateTime.now();
    final note = NoteItem(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      dateText: _formatDate(now),
    );
    setState(() {
      _notes = [note, ..._notes]; // prepend new note
      _noteController.clear();
    });
    await widget.storage.saveNotes(_notes); // encode -> save to disk
  }

  Future<void> _toggleNote(NoteItem note) async {
    setState(() {
      _notes = _notes
          .map((n) =>
              n.id == note.id ? n.copyWith(isCompleted: !n.isCompleted) : n)
          .toList();
    });
    await widget.storage.saveNotes(_notes);
  }

  Future<void> _deleteNote(NoteItem note) async {
    setState(() {
      _notes = _notes.where((n) => n.id != note.id).toList();
    });
    await widget.storage.saveNotes(_notes);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final done = _notes.where((n) => n.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.primaryContainer,
        title: Text('Hello, $_username!'),
        actions: [
          Icon(widget.isDark ? Icons.dark_mode : Icons.light_mode),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ---- Profile & settings ----
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Profile & Settings', style: textTheme.titleMedium),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                key: const Key('usernameField'),
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: (_) => _saveUsername(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              onPressed: _saveUsername,
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          key: const Key('darkModeSwitch'),
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Dark Mode'),
                          secondary: const Icon(Icons.brightness_6),
                          value: widget.isDark,
                          onChanged: widget.onThemeChanged,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---- Add note ----
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('noteField'),
                        controller: _noteController,
                        decoration: const InputDecoration(
                          labelText: 'New note',
                          prefixIcon: Icon(Icons.edit_note),
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addNote(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _addNote,
                      icon: const Icon(Icons.add),
                      tooltip: 'Add note',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Notes: ${_notes.length}  •  Completed: $done',
                    style: textTheme.bodySmall),
                const SizedBox(height: 8),

                // ---- Notes list ----
                if (_notes.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text('No notes yet. Add one above!')),
                  )
                else
                  ..._notes.map(
                    (note) => Card(
                      key: ValueKey(note.id),
                      child: ListTile(
                        leading: Checkbox(
                          value: note.isCompleted,
                          onChanged: (_) => _toggleNote(note),
                        ),
                        title: Text(
                          note.title,
                          style: TextStyle(
                            decoration: note.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(note.dateText),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: scheme.error,
                          tooltip: 'Delete',
                          onPressed: () => _deleteNote(note),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
