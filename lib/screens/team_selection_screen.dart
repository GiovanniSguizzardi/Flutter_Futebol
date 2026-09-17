import 'package:flutter/material.dart';

import '../models/team.dart';
import '../services/favorite_team_service.dart';
import '../widgets/team_shield.dart';
import 'main_screen.dart';

class TeamSelectionScreen extends StatefulWidget {
  const TeamSelectionScreen({super.key});

  @override
  State<TeamSelectionScreen> createState() => _TeamSelectionScreenState();
}

class _TeamSelectionScreenState extends State<TeamSelectionScreen> {
  final _service = FavoriteTeamService();

  String? _selectedTeamId;

  Future<void> _continue() async {
    if (_selectedTeamId == null) {
      return;
    }

    await _service.setFavoriteTeamId(_selectedTeamId!);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolha seu time')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecione o seu time favorito',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'A escolha será salva no SharedPreferences.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: Team.all.map((team) {
                  return RadioListTile<String>(
                    value: team.id,
                    groupValue: _selectedTeamId,
                    onChanged: (value) {
                      setState(() {
                        _selectedTeamId = value;
                      });
                    },
                    secondary: TeamShield(team: team),
                    title: Text(team.name),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selectedTeamId == null ? null : _continue,
                child: const Text('Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
