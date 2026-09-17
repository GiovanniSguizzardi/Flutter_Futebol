class MatchEntry {
  final int? id;
  final int round;
  final String date;
  final String homeTeamId;
  final String awayTeamId;
  final int homeGoals;
  final int awayGoals;

  const MatchEntry({
    this.id,
    required this.round,
    required this.date,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.homeGoals,
    required this.awayGoals,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'round': round,
      'date': date,
      'home_team_id': homeTeamId,
      'away_team_id': awayTeamId,
      'home_goals': homeGoals,
      'away_goals': awayGoals,
    };
  }

  factory MatchEntry.fromMap(Map<String, dynamic> map) {
    return MatchEntry(
      id: map['id'] as int?,
      round: map['round'] as int,
      date: map['date'] as String,
      homeTeamId: map['home_team_id'] as String,
      awayTeamId: map['away_team_id'] as String,
      homeGoals: map['home_goals'] as int,
      awayGoals: map['away_goals'] as int,
    );
  }
}
