import 'dart:convert';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/userServices.dart';
import 'package:http/http.dart' as http;

class HighScoreService {
  final UserService userService = UserService(); // Instantiate UserService

  Future<List<UserHighScore>> getHighScores(int round) async {
    final response = await http.get(Uri.parse(
        'https://themes-of-legend-084997a82b0a.herokuapp.com/high-score/list?round=$round'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print('API response: $body');

      // Liste pour stocker les high scores
      List<UserHighScore> userHighScores = [];

      // Parcourir chaque item dans la réponse
      for (var item in body) {
        var highScore = HighScore.fromJson(item['highScore']);
        var userUid = item['uid']; // Assuming userUid is a string

        if (userUid == null) {
          print('UserUid is null for item: $item');
          continue; // Skip this item and proceed with the next one
        }

        // Fetch userAvatarToken from UserService
        try {
          var user =
              await userService.getUser(userUid); // Fetch user by userUid
          var userAvatarToken = user.avatarToken;

          // Create UserHighScore object with available data
          var userHighScore = UserHighScore(
            uid: user.uid,
            userName: user.name, // Use user name instead of userUid
            highScore: highScore,
            userAvatarToken: userAvatarToken,
          );

          // Add to the list of high scores
          userHighScores.add(userHighScore);
        } catch (e) {
          print('Failed to fetch user details for $userUid: $e');
        }
      }

      return userHighScores;
    } else {
      throw Exception('Failed to load high scores');
    }
  }
}
