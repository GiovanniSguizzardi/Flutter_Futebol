import 'package:flutter/material.dart';

import '../models/match_entry.dart';
import '../repositories/match_repository.dart';
import '../widgets/match_card.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  final _repository = MatchRepository();

  int _round = 1;

  List<MatchEntry> _matches = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadRound();
  }

  Future<void> _loadRound() async {
    setState(() {
      _isLoading = true;
    });

    final matches = await _repository.getByRound(_round);

    setState(() {
      _matches = matches;
      _isLoading = false;
    });
  }

  void _previousRound() {
    if (_round <= 1) {
      return;
    }

    setState(() {
      _round -= 1;
    });

    _loadRound();
  }

  void _nextRound() {
    if (_round >= 38) {
      return;
    }

    setState(() {
      _round += 1;
    });

    _loadRound();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'RODADA',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _round > 1 ? _previousRound : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                _round.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _round < 38 ? _nextRound : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _matches.isEmpty
                    ? const Center(
                        child: Text('Nenhuma partida cadastrada nesta rodada.'),
                      )
                    : ListView(
                        children: _matches
                            .map((match) => MatchCard(match: match))
                            .toList(),
                      ),
          ),
        ],
      ),
    );
  }
}
