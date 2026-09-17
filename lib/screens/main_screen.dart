import 'package:flutter/material.dart';

import '../models/team.dart';
import '../services/favorite_team_service.dart';
import 'games_screen.dart';
import 'register_match_screen.dart';
import 'team_selection_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _service = FavoriteTeamService();

  int _selectedIndex = 0;

  Team? _favoriteTeam;

  @override
  void initState() {
    super.initState();

    _loadFavoriteTeam();
  }

  Future<void> _loadFavoriteTeam() async {
    final teamId = await _service.getFavoriteTeamId();

    setState(() {
      _favoriteTeam = teamId == null ? null : Team.byId(teamId);
    });
  }

  Future<void> _changeFavoriteTeam() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const TeamSelectionScreen()),
    );

    _loadFavoriteTeam();
  }

  Widget _getScreen() {
    if (_selectedIndex == 0) {
      return const GamesScreen();
    }

    return const RegisterMatchScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brasileirão'),
        actions: [
          IconButton(
            onPressed: _changeFavoriteTeam,
            icon: const Icon(Icons.swap_horiz),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              _favoriteTeam == null
                  ? ''
                  : 'Meu time: ${_favoriteTeam!.name}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
      body: _getScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sports_soccer_outlined),
            selectedIcon: Icon(Icons.sports_soccer),
            label: 'Jogos',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Cadastrar',
          ),
        ],
      ),
    );
  }
}
