import 'dart:io';
import 'dart:async';
import 'package:find_track_app/auth/bloc/auth_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_track_app/pages/favorites.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:find_track_app/pages/song_information.dart';
import 'package:find_track_app/provider/music_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  dynamic songsList;
  bool _animate = false;
  String text = "Toque para escuchar";
  
  @override
  Widget build(BuildContext context) {
    context.read<Music_Provider>().createFavoriteList();
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 100,),
              Text(text, style: TextStyle(fontSize: 20),),
              SizedBox(height: 100,),
              GestureDetector(
                onTap: () {
                  /*Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SongInformation(),
                    ),
                  );*/
                  _animate = !_animate;
                  text = "Escuchando...";
                  searchingTrack();
                  setState(() {});
                  Timer(const Duration(seconds: 10), () async {
                    text = "Toque para escuchar";
                    _animate = !_animate;
                    setState(() {});
                  });
                },
                child: AvatarGlow(
                  animate: _animate,
                  glowColor: Colors.purple,
                  endRadius: 130.0,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: Image.asset(
                        'assets/images/FindTrackAppLogo.png',
                        height: 110,
                      ),
                      radius: 110.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Row(
                children: [
                  CircleAvatar(
                    maxRadius: 25,
                    minRadius: 20,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      tooltip: "Ver favoritos",
                      icon: Icon(Icons.favorite, color: Colors.black, size: 27,),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Favorites(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  CircleAvatar(
                    maxRadius: 25,
                    minRadius: 20,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      tooltip: "Cerrar sesiíon",
                      icon: Icon(FontAwesomeIcons.powerOff, color: Colors.black, size: 27,),
                      color: Colors.white,
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                        context.read<Music_Provider>().userData();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> searchingTrack() async {
    Record record = Record();
    Directory? appDocDir = await getExternalStorageDirectory();

    if (await record.hasPermission()) {
      await record.start(
        path: '${appDocDir?.path}/newTrack.m4a',
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
    }

    bool isRecording = await record.isRecording();
    if (isRecording) {
      Timer(const Duration(seconds: 6), () async {
        String? songPath = await record.stop();
        dynamic detectedSong = await context.read<Music_Provider>().searchTrack(songPath!);

        if(detectedSong["result"] != null) {
          Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SongInformation(
              selectedTrack: detectedSong["result"],
              ),
            ),
          );
        } 
      });
    }
  }
}
