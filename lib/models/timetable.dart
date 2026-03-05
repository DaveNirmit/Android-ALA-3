import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class Timetable extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> timeSlotIds;

  Timetable({
    required this.id,
    required this.name,
    required this.timeSlotIds,
  });
}

class TimetableAdapter extends TypeAdapter<Timetable> {
  @override
  final int typeId = 3;

  @override
  Timetable read(BinaryReader reader) {
    return Timetable(
      id: reader.read(),
      name: reader.read(),
      timeSlotIds: (reader.read() as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Timetable obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.timeSlotIds);
  }
}
