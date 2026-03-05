import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../database/hive_service.dart';
import '../models/faculty.dart';
import '../models/subject.dart';
import '../theme.dart';

class AddFacultyDialog extends StatefulWidget {
  const AddFacultyDialog({super.key});

  @override
  State<AddFacultyDialog> createState() => _AddFacultyDialogState();
}

class _AddFacultyDialogState extends State<AddFacultyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<String> _selectedSubjectIds = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Faculty'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Faculty Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 20),
              const Text('Subjects They Can Teach:', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('(Leave empty if they can teach all)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: Hive.box<Subject>(HiveService.subjectsBoxName).listenable(),
                builder: (context, Box<Subject> box, _) {
                  return Column(
                    children: box.values.map((subject) {
                      return CheckboxListTile(
                        title: Text(subject.name),
                        subtitle: Text(subject.code),
                        activeColor: AppColors.primary,
                        value: _selectedSubjectIds.contains(subject.id),
                        onChanged: (selected) {
                          setState(() {
                            if (selected!) {
                              _selectedSubjectIds.add(subject.id);
                            } else {
                              _selectedSubjectIds.remove(subject.id);
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
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final faculty = Faculty(
        id: const Uuid().v4(),
        name: _nameController.text,
        subjectIds: _selectedSubjectIds,
      );
      final box = Hive.box<Faculty>(HiveService.facultyBoxName);
      await box.add(faculty);
      if (mounted) Navigator.pop(context);
    }
  }
}
