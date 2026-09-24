import 'package:flutter/material.dart';

import '../models/match_entry.dart';
import '../models/team.dart';
import '../repositories/match_repository.dart';

class RegisterMatchScreen extends StatefulWidget {
  const RegisterMatchScreen({super.key});

  @override
  State<RegisterMatchScreen> createState() => _RegisterMatchScreenState();
}

class _RegisterMatchScreenState extends State<RegisterMatchScreen> {
  final _repository = MatchRepository();
  final _formKey = GlobalKey<FormState>();

  final _roundController = TextEditingController();
  final _dateController = TextEditingController();
  final _homeGoalsController = TextEditingController();
  final _awayGoalsController = TextEditingController();

  String? _homeTeamId;
  String? _awayTeamId;

  bool _isSaving = false;

  @override
  void dispose() {
    _roundController.dispose();
    _dateController.dispose();
    _homeGoalsController.dispose();
    _awayGoalsController.dispose();

    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _dateController.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_homeTeamId == null || _awayTeamId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione os dois times.')),
      );
      return;
    }

    if (_homeTeamId == _awayTeamId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha times diferentes.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final match = MatchEntry(
      round: int.parse(_roundController.text),
      date: _dateController.text,
      homeTeamId: _homeTeamId!,
      awayTeamId: _awayTeamId!,
      homeGoals: int.parse(_homeGoalsController.text),
      awayGoals: int.parse(_awayGoalsController.text),
    );

    await _repository.insert(match);

    _formKey.currentState?.reset();
    _roundController.clear();
    _dateController.clear();
    _homeGoalsController.clear();
    _awayGoalsController.clear();

    setState(() {
      _homeTeamId = null;
      _awayTeamId = null;
      _isSaving = false;
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partida salva com sucesso!')),
    );
  }

  String? _validateGoals(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Obrigatório';
    }

    final goals = int.tryParse(value);

    if (goals == null || goals < 0) {
      return 'Inválido';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cadastrar partida',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Os dados serão persistidos no SQLite usando sqflite.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _roundController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Rodada',
                prefixIcon: Icon(Icons.format_list_numbered),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe a rodada';
                }

                final round = int.tryParse(value);

                if (round == null || round < 1 || round > 38) {
                  return 'Rodada inválida';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: _pickDate,
              decoration: const InputDecoration(
                labelText: 'Data',
                prefixIcon: Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe a data';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _homeTeamId,
              decoration: const InputDecoration(
                labelText: 'Time da casa',
                prefixIcon: Icon(Icons.home_outlined),
                border: OutlineInputBorder(),
              ),
              items: Team.all
                  .map(
                    (team) => DropdownMenuItem(
                      value: team.id,
                      child: Text(team.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _homeTeamId = value;
                });
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _awayTeamId,
              decoration: const InputDecoration(
                labelText: 'Time visitante',
                prefixIcon: Icon(Icons.flight_takeoff_outlined),
                border: OutlineInputBorder(),
              ),
              items: Team.all
                  .map(
                    (team) => DropdownMenuItem(
                      value: team.id,
                      child: Text(team.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _awayTeamId = value;
                });
              },
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _homeGoalsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Gols casa',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateGoals,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _awayGoalsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Gols visitante',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateGoals,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Salvar partida'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
