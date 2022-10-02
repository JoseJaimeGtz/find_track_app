import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_track_app/favorites.dart';
import 'package:find_track_app/home_page.dart';
import 'package:find_track_app/song_information.dart';
import 'package:find_track_app/provider/music_provider.dart';

void main() => runApp(ChangeNotifierProvider(
  create: (context) => Music_Provider(),
  child: MyApp())
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'MusicFindApp',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0x303030),
      ),
      home: HomePage(),
      initialRoute: "/homePage",
      routes: {
        "/homePage": (context) => HomePage(),
        "/songInformation": (context) => SongInformation(),
        "/favorites": (context) => Favorites(),
      },
    );
  }
}
