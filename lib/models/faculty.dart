import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Faculty extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> subjectIds;

  Faculty({
    required this.id,
    required this.name,
    required this.subjectIds,
  });
}

class FacultyAdapter extends TypeAdapter<Faculty> {
  @override
  final int typeId = 1;

  @override
  Faculty read(BinaryReader reader) {
    return Faculty(
      id: reader.read(),
      name: reader.read(),
      subjectIds: (reader.read() as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Faculty obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.subjectIds);
  }
}
