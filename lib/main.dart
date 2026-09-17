import 'package:flutter/material.dart';

import 'database/app_database.dart';
import 'screens/main_screen.dart';
import 'screens/team_selection_screen.dart';
import 'services/favorite_team_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppDatabase.instance.database;

  final favoriteTeamId = await FavoriteTeamService().getFavoriteTeamId();

  runApp(BrasileiraoApp(hasFavoriteTeam: favoriteTeamId != null));
}

class BrasileiraoApp extends StatelessWidget {
  final bool hasFavoriteTeam;

  const BrasileiraoApp({super.key, required this.hasFavoriteTeam});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brasileirão',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: hasFavoriteTeam ? const MainScreen() : const TeamSelectionScreen(),
    );
  }
}
