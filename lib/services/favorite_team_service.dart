import 'package:shared_preferences/shared_preferences.dart';

class FavoriteTeamService {
  static const _key = 'favorite_team_id';

  Future<String?> getFavoriteTeamId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_key);
  }

  Future<void> setFavoriteTeamId(String teamId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_key, teamId);
  }

  Future<void> clearFavoriteTeam() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
