import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'homepage_provider.dart';

class AudioList extends StatelessWidget {
  final _audioQuery = OnAudioQuery();

  AudioList({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HompageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: currentSongAppBar(provider: provider),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true),
        builder:
            (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data?.isEmpty ?? false) {
            return const Text("No songs found");
          } else {
            return Card(
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) =>
                      ListTile(
                        title: Text(snapshot.data![index].displayNameWOExt),
                        subtitle: Text("${snapshot.data![index].artist}"),
                        trailing: const Icon(Icons.more_horiz),
                        onTap: () {
                          provider.setMusicWithURI(snapshot.data![index]);
                          //Navigator.of(context).pop();
                        },
                      )),
            );
          }
        },
      ),
    );
  }
}

class currentSongAppBar extends StatelessWidget {
  const currentSongAppBar({
    super.key,
    required this.provider,
  });

  final HompageProvider provider;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        Navigator.of(context).pop();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(provider.songTitle,
                  style: const TextStyle(
                    fontSize: 14,
                  )),
              Text(provider.songTitle, style: TextStyle(fontSize: 12)),
            ],
          ),
          TextButton(
              onPressed: () => provider.playerStateChange(state: "pauseplay"),
              child: Consumer<HompageProvider>(builder: (context, player, _) {
                  return Image.asset(
                    player.playerImageString,
                    width: 14,
                    height: 14,
                  );
                },
              ))
        ],
      ),
    );
  }
}
