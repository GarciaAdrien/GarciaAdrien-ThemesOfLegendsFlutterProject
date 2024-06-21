class PlayerResponse {
  final String musicId;
  final String proposition;
  final String type;
  final DateTime date;

  PlayerResponse({
    required this.musicId,
    required this.proposition,
    required this.type,
    required this.date,
  });

  factory PlayerResponse.fromJson(Map<String, dynamic> json) {
    if (json['date'] == null) {
      throw FormatException('Invalid or missing date');
    }
    return PlayerResponse(
      musicId: json['musicId'] ?? 'Unknown',
      proposition: json['proposition'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      date: DateTime.tryParse(json['date']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'musicId': musicId,
      'proposition': proposition,
      'type': type,
      'date': date.toIso8601String(),
    };
  }
}

class GameResponse {
  final String? gameId;
  final Player player;
  final int roundToPlay;
  final int round;
  final List<MusicPlayed> musicPlayed;
  final bool over;

  GameResponse({
    this.gameId,
    required this.player,
    required this.roundToPlay,
    required this.round,
    required this.musicPlayed,
    required this.over,
  });

  factory GameResponse.fromJson(Map<String, dynamic> json) {
    return GameResponse(
      gameId: json['gameId'] as String?,
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      roundToPlay: json['roundToPlay'] as int,
      round: json['round'] as int,
      musicPlayed: (json['musicPlayed'] as List)
          .map((x) => MusicPlayed.fromJson(x as Map<String, dynamic>))
          .toList(),
      over: json['over'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'player': player.toJson(),
      'roundToPlay': roundToPlay,
      'round': round,
      'musicPlayed': musicPlayed.map((x) => x.toJson()).toList(),
      'over': over,
    };
  }
}

class Music {
  final String id;
  final String name;
  final String date;
  final String type;
  final List<String> aliases;

  Music({
    required this.id,
    required this.name,
    required this.date,
    required this.type,
    required this.aliases,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['id'] ?? 'Unknown',
      name: json['name'] ?? 'Unknown',
      date: json['date'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      aliases: List<String>.from(json['aliases'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'type': type,
      'aliases': aliases,
    };
  }
}

class Player {
  final String name;
  final String uid;
  final int score;
  final int combo;
  final String mastery;

  Player({
    required this.name,
    required this.uid,
    required this.score,
    required this.combo,
    required this.mastery,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String,
      uid: json['uid'] as String,
      score: json['score'] as int,
      combo: json['combo'] as int,
      mastery: json['mastery'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uid': uid,
      'score': score,
      'combo': combo,
      'mastery': mastery,
    };
  }
}

class PlayRoundResponse {
  final String token;
  final String name;
  final String date;
  final String type;

  PlayRoundResponse({
    required this.token,
    required this.name,
    required this.date,
    required this.type,
  });

  factory PlayRoundResponse.fromJson(Map<String, dynamic> json) {
    return PlayRoundResponse(
      token: json['token'],
      name: json['name'],
      date: json['date'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'name': name,
      'date': date,
      'type': type,
    };
  }
}

class User {
  final int id;
  final String name;
  final String uid;
  final String email;
  String avatarToken;
  final int gamePlayed;
  final List<HighScore> highScore;
  int totalScore;

  User({
    required this.id,
    required this.name,
    required this.uid,
    required this.email,
    required this.avatarToken,
    required this.gamePlayed,
    required this.highScore,
    required this.totalScore,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var highScoreList = json['highScore'] as List;
    List<HighScore> highScoreItems =
        highScoreList.map((i) => HighScore.fromJson(i)).toList();

    return User(
      id: json['id'],
      name: json['name'],
      uid: json['uid'],
      email: json['email'],
      avatarToken: json['avatarToken'],
      gamePlayed: json['gamePlayed'],
      highScore: highScoreItems,
      totalScore: json['totalScore'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'uid': uid,
      'email': email,
      'avatarToken': avatarToken,
      'gamePlayed': gamePlayed,
      'highScore': highScore.map((i) => i.toJson()).toList(),
      'totalScore': totalScore,
    };
  }
}

class Avatar {
  final int id;
  final String token;
  final int price;
  final bool selectable;
  final bool selected;

  Avatar({
    required this.id,
    required this.token,
    required this.price,
    required this.selectable,
    required this.selected,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      id: json['id'],
      token: json['token'],
      price: json['price'],
      selectable: json['selectable'],
      selected: json['selected'],
    );
  }
}

class HighScore {
  final int roundNumber;
  final int highScoreValue;
  final String mastery;

  HighScore({
    required this.roundNumber,
    required this.highScoreValue,
    required this.mastery,
  });

  factory HighScore.fromJson(Map<String, dynamic> json) {
    return HighScore(
      roundNumber: json['roundNumber'],
      highScoreValue: json['highScoreValue'],
      mastery: json['mastery'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roundNumber': roundNumber,
      'highScoreValue': highScoreValue,
      'mastery': mastery,
    };
  }
}

class UserHighScore {
  final String userName;
  final HighScore highScore;

  UserHighScore({
    required this.userName,
    required this.highScore,
  });

  factory UserHighScore.fromJson(Map<String, dynamic> json) {
    return UserHighScore(
      userName: json['userName'],
      highScore: HighScore.fromJson(json['highScore']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'highScore': highScore.toJson(),
    };
  }
}

class MusicPlayed {
  final String token;
  final String name;
  final String date;
  final String type;
  final List<String> aliases;

  MusicPlayed({
    required this.token,
    required this.name,
    required this.date,
    required this.type,
    required this.aliases,
  });

  factory MusicPlayed.fromJson(Map<String, dynamic> json) {
    return MusicPlayed(
      token: json['token'] ?? 'Unknown',
      name: json['name'] ?? 'Unknown',
      date: json['date'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      aliases: List<String>.from(json['aliases'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'name': name,
      'date': date,
      'type': type,
      'aliases': aliases,
    };
  }
}
