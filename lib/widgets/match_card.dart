import 'package:flutter/material.dart';

import '../models/match_entry.dart';
import '../models/team.dart';
import 'team_shield.dart';

class MatchCard extends StatelessWidget {
  final MatchEntry match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final homeTeam = Team.byId(match.homeTeamId);
    final awayTeam = Team.byId(match.awayTeamId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              match.date,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    TeamShield(team: homeTeam),
                    const SizedBox(height: 4),
                    Text(homeTeam.name),
                  ],
                ),
                Text(
                  '${match.homeGoals} x ${match.awayGoals}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  children: [
                    TeamShield(team: awayTeam),
                    const SizedBox(height: 4),
                    Text(awayTeam.name),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
