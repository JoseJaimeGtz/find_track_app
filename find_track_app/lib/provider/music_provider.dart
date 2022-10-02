import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Music_Provider extends ChangeNotifier {
  List<dynamic> _tracks = [];
  List<dynamic> get getTracks => _tracks;

  Future<dynamic> searchTrack(trackPath) async {
    File track = File(trackPath!);
    Uint8List fileBytes = await track.readAsBytesSync();
    String trackString = base64Encode(fileBytes);

    await dotenv.load(fileName: ".env");
    var api_token = dotenv.env['API_TOKEN'];

    var response = await http.post(Uri.parse('https://api.audd.io/'), body: {
      "method": 'recognize',
      "api_token": api_token,
      "audio": "${trackString}",
      "return": 'apple_music,spotify,deezer',
    });

    if (response.statusCode == 200) {
      var json_response = jsonDecode(response.body);
      notifyListeners();
      return json_response;
    }
  }

  void addFavoriteTrack(dynamic track){
    //int exist = _tracks.indexWhere((track) => track.title == );
    //if (exist == -1) {
    _tracks.add(track);
    notifyListeners();
  }
  void deleteFavoriteTrack(dynamic track){
    _tracks.remove(track);
    notifyListeners();
  }
}
