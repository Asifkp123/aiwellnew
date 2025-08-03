import 'package:flutter/material.dart';

class SleepQuality {
  final String name;
  final String value;
  final Color color;
  final IconData icon;

  const SleepQuality({
    required this.name,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  String toString() => 'SleepQuality(name: $name, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SleepQuality && other.name == name && other.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
