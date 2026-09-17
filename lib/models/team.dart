import 'package:flutter/material.dart';

class Team {
  final String id;
  final String name;
  final Color color;
  final String initials;

  const Team({
    required this.id,
    required this.name,
    required this.color,
    required this.initials,
  });

  static const List<Team> all = [
    Team(
      id: 'palmeiras',
      name: 'Palmeiras',
      color: Color(0xFF1B5E20),
      initials: 'PAL',
    ),
    Team(
      id: 'flamengo',
      name: 'Flamengo',
      color: Color(0xFFC62828),
      initials: 'FLA',
    ),
    Team(
      id: 'corinthians',
      name: 'Corinthians',
      color: Color(0xFF212121),
      initials: 'COR',
    ),
    Team(
      id: 'sao_paulo',
      name: 'São Paulo',
      color: Color(0xFFB71C1C),
      initials: 'SPF',
    ),
    Team(
      id: 'cruzeiro',
      name: 'Cruzeiro',
      color: Color(0xFF0D47A1),
      initials: 'CRU',
    ),
  ];

  static Team byId(String id) {
    return all.firstWhere(
      (team) => team.id == id,
      orElse: () => all.first,
    );
  }
}
