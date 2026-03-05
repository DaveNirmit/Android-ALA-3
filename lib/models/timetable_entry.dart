import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class TimetableEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String timetableId;

  @HiveField(2)
  String timeSlotId;

  @HiveField(3)
  int dayIndex; // 0 for Monday, 5 for Saturday

  @HiveField(4)
  String subjectId;

  @HiveField(5)
  String facultyId;

  TimetableEntry({
    required this.id,
    required this.timetableId,
    required this.timeSlotId,
    required this.dayIndex,
    required this.subjectId,
    required this.facultyId,
  });
}

class TimetableEntryAdapter extends TypeAdapter<TimetableEntry> {
  @override
  final int typeId = 4;

  @override
  TimetableEntry read(BinaryReader reader) {
    return TimetableEntry(
      id: reader.read(),
      timetableId: reader.read(),
      timeSlotId: reader.read(),
      dayIndex: reader.read(),
      subjectId: reader.read(),
      facultyId: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, TimetableEntry obj) {
    writer.write(obj.id);
    writer.write(obj.timetableId);
    writer.write(obj.timeSlotId);
    writer.write(obj.dayIndex);
    writer.write(obj.subjectId);
    writer.write(obj.facultyId);
  }
}
