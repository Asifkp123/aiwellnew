import 'package:flutter/material.dart';
import '../../domain/entities/medicine_schedule.dart';

class MedicineScheduleModel extends MedicineSchedule {
  MedicineScheduleModel({
    required super.id,
    required super.medicineName,
    required super.startDate,
    required super.endDate,
    required super.time,
    super.isTaken = false,
  });

  factory MedicineScheduleModel.fromEntity(MedicineSchedule entity) {
    return MedicineScheduleModel(
      id: entity.id,
      medicineName: entity.medicineName,
      startDate: entity.startDate,
      endDate: entity.endDate,
      time: entity.time,
      isTaken: entity.isTaken,
    );
  }

  MedicineSchedule toEntity() {
    return MedicineSchedule(
      id: id,
      medicineName: medicineName,
      startDate: startDate,
      endDate: endDate,
      time: time,
      isTaken: isTaken,
    );
  }

  @override
  MedicineScheduleModel copyWith({
    String? id,
    String? medicineName,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? time,
    bool? isTaken,
  }) {
    return MedicineScheduleModel(
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

  factory MedicineScheduleModel.fromJson(Map<String, dynamic> json) {
    final timeParts = json['time'].split(':');
    return MedicineScheduleModel(
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
