import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../database/hive_service.dart';
import '../models/subject.dart';
import '../models/faculty.dart';
import '../models/time_slot.dart';
import '../models/timetable.dart';
import '../models/timetable_entry.dart';
import '../theme.dart';
import '../widgets/slot_edit_dialog.dart';

class TimetableGridScreen extends StatelessWidget {
  final Timetable timetable;

  const TimetableGridScreen({super.key, required this.timetable});

  static const List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(timetable.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tap a slot to assign subject and faculty')),
              );
            },
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TimetableEntry>(HiveService.entriesBoxName).listenable(),
        builder: (context, Box<TimetableEntry> entryBox, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  defaultColumnWidth: const FixedColumnWidth(100.0),
                  border: TableBorder.all(color: Colors.grey.shade300),
                  children: [
                    // Header Row
                    TableRow(
                      decoration: const BoxDecoration(color: AppColors.primary),
                      children: [
                        const TableCell(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Time', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                        ...days.map((day) => TableCell(
                          child: Padding(padding: const EdgeInsets.all(8.0), child: Text(day, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        )),
                      ],
                    ),
                    // Data Rows
                    ...timetable.timeSlotIds.map((slotId) {
                      final slot = Hive.box<TimeSlot>(HiveService.timeSlotsBoxName).values.firstWhere((s) => s.id == slotId);
                      return TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(slot.format, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                            ),
                          ),
                          ...List.generate(6, (dayIndex) {
                            final entry = entryBox.values.cast<TimetableEntry?>().firstWhere(
                                  (e) => e?.timetableId == timetable.id && e?.timeSlotId == slotId && e?.dayIndex == dayIndex,
                                  orElse: () => null,
                                );
                            return TableCell(
                              child: _buildSlotCell(context, slotId, dayIndex, entry),
                            );
                          }),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlotCell(BuildContext context, String slotId, int dayIndex, TimetableEntry? entry) {
    Subject? subject;
    Faculty? faculty;

    if (entry != null) {
      subject = Hive.box<Subject>(HiveService.subjectsBoxName).values.firstWhere((s) => s.id == entry.subjectId);
      faculty = Hive.box<Faculty>(HiveService.facultyBoxName).values.firstWhere((f) => f.id == entry.facultyId);
    }

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SlotEditDialog(
            timetableId: timetable.id,
            slotId: slotId,
            dayIndex: dayIndex,
            existingEntry: entry,
          ),
        );
      },
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: subject != null ? Color(subject.colorValue).withOpacity(0.2) : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (subject != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(subject.colorValue),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  subject.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                faculty?.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9),
              ),
            ] else
              const Text('Free', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
