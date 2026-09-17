import 'package:flutter/material.dart';

import 'profile_header.dart';
import 'info_row.dart';
import 'data.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Bricolage Grotesque'),
      home: const ProfileScreen(),
    ),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Column(
        children: [
          const ProfileHeader(name: myName, university: myUniversity),
          ...facts.map((fact) => InfoRow(label: fact.label, value: fact.value)),
        ],
      ),
    );
  }
}
