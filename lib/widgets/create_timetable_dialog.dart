import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../database/hive_service.dart';
import '../models/time_slot.dart';
import '../models/timetable.dart';
import '../theme.dart';

class CreateTimetableDialog extends StatefulWidget {
  const CreateTimetableDialog({super.key});

  @override
  State<CreateTimetableDialog> createState() => _CreateTimetableDialogState();
}

class _CreateTimetableDialogState extends State<CreateTimetableDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<String> _selectedSlotIds = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Timetable'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Timetable Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 20),
              const Text('Select Time Slots:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: Hive.box<TimeSlot>(HiveService.timeSlotsBoxName).listenable(),
                builder: (context, Box<TimeSlot> box, _) {
                  if (box.isEmpty) {
                    return const Text('No time slots available. Please add some first.');
                  }
                  return Column(
                    children: box.values.map((slot) {
                      return CheckboxListTile(
                        title: Text(slot.format),
                        activeColor: AppColors.primary,
                        value: _selectedSlotIds.contains(slot.id),
                        onChanged: (selected) {
                          setState(() {
                            if (selected!) {
                              _selectedSlotIds.add(slot.id);
                            } else {
                              _selectedSlotIds.remove(slot.id);
                            }
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedSlotIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one time slot')),
        );
        return;
      }
      final timetable = Timetable(
        id: const Uuid().v4(),
        name: _nameController.text,
        timeSlotIds: _selectedSlotIds,
      );
      final box = Hive.box<Timetable>(HiveService.timetablesBoxName);
      await box.add(timetable);
      if (mounted) Navigator.pop(context);
    }
  }
}
