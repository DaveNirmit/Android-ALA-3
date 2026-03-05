import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/subject.dart';
import '../models/faculty.dart';
import '../models/time_slot.dart';
import '../models/timetable.dart';
import '../models/timetable_entry.dart';

class HiveService {
  static const String subjectsBoxName = 'subjectsBox';
  static const String facultyBoxName = 'facultyBox';
  static const String timeSlotsBoxName = 'timeSlotsBox';
  static const String timetablesBoxName = 'timetablesBox';
  static const String entriesBoxName = 'timetableEntriesBox';

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters (Note: These .g.dart files need to be generated, 
    // but I will provide the manual registration if needed or assume generated)
    Hive.registerAdapter(SubjectAdapter());
    Hive.registerAdapter(FacultyAdapter());
    Hive.registerAdapter(TimeSlotAdapter());
    Hive.registerAdapter(TimetableAdapter());
    Hive.registerAdapter(TimetableEntryAdapter());

    await Hive.openBox<Subject>(subjectsBoxName);
    await Hive.openBox<Faculty>(facultyBoxName);
    await Hive.openBox<TimeSlot>(timeSlotsBoxName);
    await Hive.openBox<Timetable>(timetablesBoxName);
    await Hive.openBox<TimetableEntry>(entriesBoxName);

    await _initDemoData();
  }

  Future<void> _initDemoData() async {
    final subBox = Hive.box<Subject>(subjectsBoxName);
    if (subBox.isEmpty) {
      final os = Subject(id: const Uuid().v4(), name: 'Operating System', code: 'CS101', colorValue: Colors.blue.value);
      final da = Subject(id: const Uuid().v4(), name: 'Data Analysis', code: 'CS102', colorValue: Colors.green.value);
      final web = Subject(id: const Uuid().v4(), name: 'Web Development', code: 'CS103', colorValue: Colors.orange.value);
      final net = Subject(id: const Uuid().v4(), name: 'Computer Networks', code: 'CS104', colorValue: Colors.purple.value);

      await subBox.addAll([os, da, web, net]);

      final facBox = Hive.box<Faculty>(facultyBoxName);
      final drPatel = Faculty(id: const Uuid().v4(), name: 'Dr. Patel', subjectIds: [os.id]);
      final profMehta = Faculty(id: const Uuid().v4(), name: 'Prof. Mehta', subjectIds: [da.id]);
      final drShah = Faculty(id: const Uuid().v4(), name: 'Dr. Shah', subjectIds: [web.id]);
      
      await facBox.addAll([drPatel, profMehta, drShah]);

      final slotBox = Hive.box<TimeSlot>(timeSlotsBoxName);
      final slot1 = TimeSlot(id: const Uuid().v4(), startHour: 9, startMinute: 0, endHour: 10, endMinute: 0);
      final slot2 = TimeSlot(id: const Uuid().v4(), startHour: 10, startMinute: 0, endHour: 11, endMinute: 0);
      final slot3 = TimeSlot(id: const Uuid().v4(), startHour: 11, startMinute: 15, endHour: 12, endMinute: 15);

      await slotBox.addAll([slot1, slot2, slot3]);

      final ttBox = Hive.box<Timetable>(timetablesBoxName);
      final demoTT = Timetable(
        id: const Uuid().v4(), 
        name: 'Semester 4 Timetable', 
        timeSlotIds: [slot1.id, slot2.id, slot3.id]
      );
      await ttBox.add(demoTT);
      
      final entryBox = Hive.box<TimetableEntry>(entriesBoxName);
      // Mon 9-10 OS Dr Patel
      await entryBox.add(TimetableEntry(
        id: const Uuid().v4(),
        timetableId: demoTT.id,
        timeSlotId: slot1.id,
        dayIndex: 0,
        subjectId: os.id,
        facultyId: drPatel.id
      ));
    }
  }
}
