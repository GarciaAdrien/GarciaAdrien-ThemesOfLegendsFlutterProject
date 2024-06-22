// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class MusicService {
  String baseUrl = "https://themes-of-legend-084997a82b0a.herokuapp.com/";
  MusicService(this.baseUrl);

  Future<List<Music>> getMusicList() async {
    final url = Uri.parse('$baseUrl/music/list');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> musicListJson = jsonDecode(response.body);
      final List<Music> musicList =
          musicListJson.map((json) => Music.fromJson(json)).toList();
      return musicList;
    } else {
      throw Exception('Failed to fetch music list: ${response.statusCode}');
    }
  }
}
