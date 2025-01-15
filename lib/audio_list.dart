import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioList extends StatelessWidget {
  final _audioQuery = OnAudioQuery();
  AudioList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true),
      builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
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
                itemBuilder: (context, index) => ListTile(
                      title: Text(snapshot.data![index].displayNameWOExt),
                      subtitle: Text("${snapshot.data![index].artist}"),
                      trailing: const Icon(Icons.more_horiz),
                    )),
          );
        }
      },
    );
  }
}
