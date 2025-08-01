import 'package:flutter/material.dart';

class MoodOption {
  final String name;
  final String emoji;
  final Color color;

  const MoodOption({
    required this.name,
    required this.emoji,
    required this.color,
  });

  @override
  String toString() => 'MoodOption(name: $name, emoji: $emoji)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MoodOption && other.name == name && other.emoji == emoji;
  }

  @override
  int get hashCode => name.hashCode ^ emoji.hashCode;
}
