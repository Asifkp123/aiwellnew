import 'package:flutter/material.dart';

class WorkoutRating {
  final String name;
  final String intensity;
  final Color color;

  const WorkoutRating({
    required this.name,
    required this.intensity,
    required this.color,
  });

  @override
  String toString() => 'WorkoutRating(name: $name, intensity: $intensity)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutRating &&
        other.name == name &&
        other.intensity == intensity;
  }

  @override
  int get hashCode => name.hashCode ^ intensity.hashCode;
}

class WorkoutType {
  final String name;
  final String category;
  final IconData icon;

  const WorkoutType({
    required this.name,
    required this.category,
    required this.icon,
  });

  @override
  String toString() => 'WorkoutType(name: $name, category: $category)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutType &&
        other.name == name &&
        other.category == category;
  }

  @override
  int get hashCode => name.hashCode ^ category.hashCode;
}
