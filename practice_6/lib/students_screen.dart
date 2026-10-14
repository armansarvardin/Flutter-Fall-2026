import 'package:flutter/material.dart';

import 'routes.dart';
import 'students.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Students')),
    body: ListView(
      children: students
          .map(
            (student) => ListTile(
              title: Text(student.name),
              subtitle: Text(student.group),
              trailing: const Icon(Icons.chevron_right),
              leading: CircleAvatar(child: Text(student.name[0])),
              onTap: () => Navigator.of(
                context,
              ).pushNamed(Routes.student, arguments: student),
            ),
          )
          .toList(),
    ),
  );
}