// Lab 11 — Offline-First Notes & Settings Vault
// Author: Aidana Yerkengazina (Айдана Еркенгазина)

/// Domain model for a single note.
class NoteItem {
  final String id;
  final String title;
  final String dateText;
  final bool isCompleted;

  const NoteItem({
    required this.id,
    required this.title,
    required this.dateText,
    this.isCompleted = false,
  });

  NoteItem copyWith({bool? isCompleted}) => NoteItem(
        id: id,
        title: title,
        dateText: dateText,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  /// Object -> Map (ready for jsonEncode).
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateText': dateText,
        'isCompleted': isCompleted,
      };

  /// Map (from jsonDecode) -> Object, with null-safe defaults.
  factory NoteItem.fromJson(Map<String, dynamic> json) => NoteItem(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        dateText: json['dateText'] as String? ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false,
      );
}
