import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../database/hive_service.dart';
import '../models/subject.dart';
import '../models/faculty.dart';
import '../models/timetable_entry.dart';

class SlotEditDialog extends StatefulWidget {
  final String timetableId;
  final String slotId;
  final int dayIndex;
  final TimetableEntry? existingEntry;

  const SlotEditDialog({
    super.key,
    required this.timetableId,
    required this.slotId,
    required this.dayIndex,
    this.existingEntry,
  });

  @override
  State<SlotEditDialog> createState() => _SlotEditDialogState();
}

class _SlotEditDialogState extends State<SlotEditDialog> {
  String? _selectedSubjectId;
  String? _selectedFacultyId;

  @override
  void initState() {
    super.initState();
    if (widget.existingEntry != null) {
      _selectedSubjectId = widget.existingEntry!.subjectId;
      _selectedFacultyId = widget.existingEntry!.facultyId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjects = Hive.box<Subject>(HiveService.subjectsBoxName).values.toList();
    final allFaculty = Hive.box<Faculty>(HiveService.facultyBoxName).values.toList();

    // Filter faculty based on selected subject
    final filteredFaculty = allFaculty.where((f) {
      if (_selectedSubjectId == null) return false;
      return f.subjectIds.isEmpty || f.subjectIds.contains(_selectedSubjectId);
    }).toList();

    return AlertDialog(
      title: Text(widget.existingEntry == null ? 'Assign Slot' : 'Edit Slot'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedSubjectId,
            hint: const Text('Select Subject'),
            items: subjects.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
            onChanged: (val) {
              setState(() {
                _selectedSubjectId = val;
                _selectedFacultyId = null; // Reset faculty when subject changes
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedFacultyId,
            hint: const Text('Select Faculty'),
            items: filteredFaculty.map((f) => DropdownMenuItem(value: f.id, child: Text(f.name))).toList(),
            onChanged: (val) => setState(() => _selectedFacultyId = val),
          ),
        ],
      ),
      actions: [
        if (widget.existingEntry != null)
          TextButton(
            onPressed: () {
              widget.existingEntry!.delete();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }

  void _save() async {
    if (_selectedSubjectId == null || _selectedFacultyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select both subject and faculty')));
      return;
    }

    final entryBox = Hive.box<TimetableEntry>(HiveService.entriesBoxName);

    // Validation: Faculty conflict (same time/day across any timetable)
    final facultyConflict = entryBox.values.any((e) =>
        e.dayIndex == widget.dayIndex &&
        e.timeSlotId == widget.slotId &&
        e.facultyId == _selectedFacultyId &&
        e.id != widget.existingEntry?.id);

    if (facultyConflict) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Faculty is already busy in another class at this time!')));
      return;
    }

    if (widget.existingEntry != null) {
      widget.existingEntry!.subjectId = _selectedSubjectId!;
      widget.existingEntry!.facultyId = _selectedFacultyId!;
      await widget.existingEntry!.save();
    } else {
      final newEntry = TimetableEntry(
        id: const Uuid().v4(),
        timetableId: widget.timetableId,
        timeSlotId: widget.slotId,
        dayIndex: widget.dayIndex,
        subjectId: _selectedSubjectId!,
        facultyId: _selectedFacultyId!,
      );
      await entryBox.add(newEntry);
    }

    if (mounted) Navigator.pop(context);
  }
}
