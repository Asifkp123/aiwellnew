import 'package:flutter/material.dart';

class MedicineSchedule {
  final String id;
  final String medicineName;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay time;
  final bool isTaken;

  MedicineSchedule({
    required this.id,
    required this.medicineName,
    required this.startDate,
    required this.endDate,
    required this.time,
    this.isTaken = false,
  });

  MedicineSchedule copyWith({
    String? id,
    String? medicineName,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? time,
    bool? isTaken,
  }) {
    return MedicineSchedule(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      time: time ?? this.time,
      isTaken: isTaken ?? this.isTaken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicine': medicineName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'status': isTaken,
    };
  }

  factory MedicineSchedule.fromJson(Map<String, dynamic> json) {
    final timeParts = json['time'].split(':');
    return MedicineSchedule(
      id: json['id'],
      medicineName: json['medicine'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      isTaken: json['status'] ?? false,
    );
  }
}
