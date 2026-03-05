import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Subject extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String code;

  @HiveField(3)
  int colorValue;

  Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.colorValue,
  });
}

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 0;

  @override
  Subject read(BinaryReader reader) {
    return Subject(
      id: reader.read(),
      name: reader.read(),
      code: reader.read(),
      colorValue: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.code);
    writer.write(obj.colorValue);
  }
}
