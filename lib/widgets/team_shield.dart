import 'package:flutter/material.dart';

import '../models/team.dart';

class TeamShield extends StatelessWidget {
  final Team team;
  final double size;

  const TeamShield({super.key, required this.team, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: team.color,
      child: Text(
        team.initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size / 3.2,
        ),
      ),
    );
  }
}
