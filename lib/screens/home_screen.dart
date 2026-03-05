import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../database/hive_service.dart';
import '../models/subject.dart';
import '../models/faculty.dart';
import '../models/timetable.dart';
import '../theme.dart';
import '../widgets/add_subject_dialog.dart';
import '../widgets/add_faculty_dialog.dart';
import '../widgets/create_timetable_dialog.dart';
import 'timetable_grid_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable Generator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildMainButtons(context),
              const SizedBox(height: 40),
              const Text(
                'Recent Timetables',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTimetableList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainButtons(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: [
        _MenuCard(
          title: 'Create Timetable',
          icon: Icons.calendar_today,
          onTap: () => showDialog(
            context: context,
            builder: (context) => const CreateTimetableDialog(),
          ),
        ),
        _MenuCard(
          title: 'Add Subject',
          icon: Icons.book_outlined,
          onTap: () => showDialog(
            context: context,
            builder: (context) => const AddSubjectDialog(),
          ),
        ),
        _MenuCard(
          title: 'Add Faculty',
          icon: Icons.person_add_outlined,
          onTap: () => showDialog(
            context: context,
            builder: (context) => const AddFacultyDialog(),
          ),
        ),
        _MenuCard(
          title: 'Manage Data',
          icon: Icons.settings_suggest_outlined,
          onTap: () {
            // Future: add settings or bulk management
          },
        ),
      ],
    );
  }

  Widget _buildTimetableList(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Timetable>(HiveService.timetablesBoxName).listenable(),
      builder: (context, Box<Timetable> box, _) {
        if (box.isEmpty) {
          return const Center(child: Text('No timetables created yet.'));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: box.length,
          itemBuilder: (context, index) {
            final tt = box.getAt(index);
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.table_chart, color: Colors.white),
                ),
                title: Text(tt!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${tt.timeSlotIds.length} Time Slots'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => tt.delete(),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimetableGridScreen(timetable: tt),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
