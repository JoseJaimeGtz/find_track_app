import 'package:flutter/material.dart';
import 'package:find_track_app/item_track.dart';
import 'package:find_track_app/provider/music_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Favorites extends StatelessWidget {

  /*
  final List<Map<String, String>> _listElements = [
    {
      "title": "Star wars",
      "description": "Ranking: ★★★",
      "image": "https://i.imgur.com/tpHc9cS.jpg",
    },
    {
      "title": "Black widow",
      "description": "Ranking: ★★★★",
      "image": "https://i.imgur.com/0NTTbFn.jpg",
    },
    {
      "title": "Frozen 2",
      "description": "Ranking: ★★★",
      "image": "https://i.imgur.com/noNCN3V.jpg",
    },
    {
      "title": "Joker",
      "description": "Ranking: ★★★★",
      "image": "https://i.imgur.com/trdzMAl.jpg",
    },
  ];
  */

  Favorites({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: Column(
        children: [
          _tracksArea(context),
        ],
      )
    );
  }

  Widget _tracksArea(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 87,
      child: _tracksList(context),
    );
  }

  Widget _tracksList(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      //shrinkWrap: true,
      itemCount: context.watch<Music_Provider>().getTracks.length,
      itemBuilder: (BuildContext context, int index) {
        var _itemTrack = context.watch<Music_Provider>().getTracks[index];
        return ItemTrack(track: _itemTrack);
      },
    );
  }
}
