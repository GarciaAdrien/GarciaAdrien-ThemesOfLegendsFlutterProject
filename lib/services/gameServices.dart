import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blindtestlol_flutter_app/models/models.dart';

class GameService {
  String baseUrl = "https://themes-of-legend-084997a82b0a.herokuapp.com/";

  GameService(this.baseUrl);

  Future<GameResponse> createGame(String userUid, int roundToPlay) async {
    final url = Uri.parse(
        '$baseUrl/game/create?userUid=$userUid&roundToPlay=$roundToPlay');
    final response =
        await http.post(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      print('Failed to create game: ${response.statusCode}');
      throw Exception('Failed to create game: ${response.statusCode}');
    }
    final gameResponse = GameResponse.fromJson(jsonDecode(response.body));
    print('createGame response: $gameResponse');
    return gameResponse;
  }

  Future<PlayRoundResponse?> playRound(String gameId) async {
    final url = Uri.parse('$baseUrl/game/play-round?gameId=$gameId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final playRoundResponse =
            PlayRoundResponse.fromJson(jsonDecode(response.body));
        print('playRound response: $playRoundResponse');
        return playRoundResponse;
      } else {
        print('Error playing round with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Failed to play round due to an error: $e');
      return null;
    }
  }

  Future<GameResponse> postPlayerResponse({
    required String gameId,
    required String musicToken,
    required String proposition,
    required String type,
    required String date,
  }) async {
    final url = Uri.parse('$baseUrl/game/player-response?gameId=$gameId');
    final body = jsonEncode({
      'musicToken': musicToken,
      'proposition': proposition,
      'type': type,
      'date': date,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/hal+json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      print('postPlayerResponse response: $responseJson');
      return GameResponse.fromJson(responseJson);
    } else {
      print(
          'Failed to submit player response: ${response.statusCode} - ${response.body}');
      throw Exception(
          'Failed to submit player response: ${response.statusCode} - ${response.body}');
    }
  }
}
