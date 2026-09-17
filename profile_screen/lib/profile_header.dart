import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  final String name;
  final String university;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(university, style: Theme.of(context).textTheme.bodyLarge),
          Image.asset('assets/images/profile_pic.png', width: 100, height: 100),
        ],
      ),
    );
  }
}
