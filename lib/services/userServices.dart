// ignore: file_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class UserService {
  final String baseUrl = 'https://themes-of-legend-084997a82b0a.herokuapp.com/';

  UserService();

  Future<User> createUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}user/create'),
      headers: <String, String>{
        'accept': 'application/hal+json',
      },
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    print(response.body);
    print('${baseUrl}user/create?name=$name&email=$email&password=$password');

    if (response.statusCode == 200 || response.statusCode == 405) {
      try {
        // Attempt to decode JSON response
        var decodedJson = jsonDecode(response.body);

        // Check if decodedJson is a Map<String, dynamic>
        if (decodedJson is Map<String, dynamic>) {
          // Return User object if decoding successful
          return User.fromJson(decodedJson);
        } else {
          throw FormatException('Invalid JSON format');
        }
      } catch (e) {
        // Handle JSON decoding exception
        throw Exception('Failed to decode user data: $e');
      }
    } else {
      // Handle non-200 status codes
      throw Exception('Failed to create user. Status: ${response.statusCode}');
    }
  }

  Future<User> connectUser(String name, String password) async {
    final url =
        Uri.parse('${baseUrl}user/connect?name=$name&password=$password');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to connect user. Status: ${response.statusCode}');
    }
  }

  Future<User> updatePassword(String userUid, String newPassword) async {
    final response = await http.put(
      Uri.parse(
          '${baseUrl}user/change-password?uid=$userUid&password=$newPassword'),
      headers: <String, String>{
        'accept': 'application/hal+json',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to update password. Status: ${response.statusCode}');
    }
  }

  Future<User> getUser(String userUid) async {
    final url = Uri.parse('${baseUrl}user/get?uid=$userUid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to connect user. Status: ${response.statusCode}');
    }
  }

  Future<List<Avatar>> getAllAvatars(String userUid, bool isSelectable) async {
    final url = Uri.parse('${baseUrl}user/avatars?uid=$userUid');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      List<Avatar> avatars =
          List<Avatar>.from(list.map((model) => Avatar.fromJson(model)));

      // Définir la liste des avatars en fonction de la valeur de isSelectable
      List<Avatar> filteredAvatars = isSelectable
          ? avatars.where((avatar) => avatar.selectable).toList()
          : avatars.where((avatar) => !avatar.selectable).toList();

      // Tri des avatars par prix croissant
      filteredAvatars.sort((a, b) => a.price.compareTo(b.price));

      return filteredAvatars;
    } else {
      throw Exception('Failed to load avatars. Status: ${response.statusCode}');
    }
  }

  Future<void> buyAvatar(String userUid, int avatarId) async {
    final url =
        Uri.parse('${baseUrl}user/buy-avatar?uid=$userUid&avatar=$avatarId');

    final response = await http.put(url);

    if (response.statusCode == 200) {
      // Successful purchase
      print('Avatar purchased successfully');
    } else {
      // Purchase failed
      throw Exception('Failed to buy avatar. Status: ${response.statusCode}');
    }
  }

  Future<void> changeAvatar(String userUid, int avatarId) async {
    final url =
        Uri.parse('${baseUrl}user/change-avatar?uid=$userUid&avatar=$avatarId');

    final response = await http.put(url);

    if (response.statusCode == 200) {
      // Successful avatar change
      print('Avatar changed successfully');
    } else {
      // Avatar change failed
      throw Exception(
          'Failed to change avatar. Status: ${response.statusCode}');
    }
  }
}
