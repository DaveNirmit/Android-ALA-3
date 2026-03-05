import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class TimeSlot extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  int startHour;

  @HiveField(2)
  int startMinute;

  @HiveField(3)
  int endHour;

  @HiveField(4)
  int endMinute;

  TimeSlot({
    required this.id,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
  });

  String get format {
    final start = TimeOfDay(hour: startHour, minute: startMinute);
    final end = TimeOfDay(hour: endHour, minute: endMinute);
    return '${_formatTime(start)} - ${_formatTime(end)}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class TimeSlotAdapter extends TypeAdapter<TimeSlot> {
  @override
  final int typeId = 2;

  @override
  TimeSlot read(BinaryReader reader) {
    return TimeSlot(
      id: reader.read(),
      startHour: reader.read(),
      startMinute: reader.read(),
      endHour: reader.read(),
      endMinute: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, TimeSlot obj) {
    writer.write(obj.id);
    writer.write(obj.startHour);
    writer.write(obj.startMinute);
    writer.write(obj.endHour);
    writer.write(obj.endMinute);
  }
}
