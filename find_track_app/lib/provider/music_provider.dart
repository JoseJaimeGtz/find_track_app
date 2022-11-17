import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Music_Provider extends ChangeNotifier {
  List<dynamic> _tracks = [];
  List<dynamic> get getTracks => _tracks;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  

  String userData() {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }

  void createFavoriteList() async {
    String id = userData();
    final response = await responseFromDatabase(id);
    if(_tracks.isEmpty) {
      for(var i = 0; i < response['fav'].length; i++) {
        _tracks.add(response['fav'][i]);
      }
    }
  }

  void addFavoriteTrack(dynamic track) async{
    String id = userData();
    final response = await responseFromDatabase(id);
    bool alreadyAdded = false;
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    print(response['fav']);
    // print(response.docs.length);
    print(_tracks.length);
    for(var i = 0; i < _tracks.length; i++) {
      if(track['title'] == response['fav'][i]['title']) {
        alreadyAdded = true;
        break;
      }
      print('hola');
    }
    if (!alreadyAdded) {
      dynamic addTrack = {
        "title": track["title"],
        "album": track["album"],
        "artist": track["artist"],
        "link": track["song_link"],
        "song_link": track["song_link"],
        "release_date": track["release_date"],
        "apple_music": track["apple_music"]["url"],
        "image": track["spotify"]["album"]["images"][0]["url"],
        "spotify": track["spotify"]["external_urls"]["spotify"],
      };
      _tracks.add(addTrack);
      db.collection('tracks').doc(id).update({'fav': FieldValue.arrayUnion([addTrack])});
    }
    notifyListeners();
  }

  dynamic responseFromDatabase(id) async {
    final DocumentSnapshot res = await FirebaseFirestore.instance.collection('tracks').doc(id).get();
    return res;
  }

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

  void deleteFavoriteTrack(dynamic track) async {
    String id = userData();
    dynamic removeTrack = track['song_link'];
    print(removeTrack);
    _tracks.removeWhere((item) => item == track);
    db.collection('tracks').doc(id).update({'fav': FieldValue.arrayRemove([track])});
    notifyListeners();
  }
}
