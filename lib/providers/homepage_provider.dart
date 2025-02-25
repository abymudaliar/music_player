import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/helpers/request_permission.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class HompageProvider extends ChangeNotifier {
  final player = AudioPlayer();
  final _audioQuery = OnAudioQuery();
  String _playerImageString = "assets/images/play-button.png";
  String get playerImageString => _playerImageString;
  double _playerDuration = 0.0;
  double get playerDuration => _playerDuration;
  String _songTitle = "";
  String get songTitle => _songTitle;

  final playList = <int, AudioSource>{};

  void setPlayList() async {
    final bool audioGranted = await Permission.audio.isGranted;
    final bool storageGranted = await Permission.storage.isGranted;
    if(audioGranted || storageGranted) {
      var tes = await _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true);
      for (int i = 0; i < tes.length; i++) {
        var audioSource = AudioSource.uri(Uri.parse(tes[i].uri ?? ""));
        playList[i] = audioSource;
      }

      await player.setAudioSource(playList[0]!);
      _playerDuration = player.duration?.inSeconds.toDouble() ?? 0.0;
    }
    else{
      await requestPermission();
      setPlayList();
    }
  }

  void setMusic() async {
    //  await player.setAsset("assets/audio/spinning-head.mp3");
    // _playerDuration = player.duration?.inSeconds.toDouble() ?? 0.0;
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {}
    });
  }

  void setMusicWithURI(SongModel song) async {
    try {
      await player.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));
      _playerDuration = player.duration?.inSeconds.toDouble() ?? 0.0;
      _songTitle = song.title;
      if (!player.playing) {
        player.play();
        _playerImageString = "assets/images/pause.png";
      }
      notifyListeners();
    } on Exception {
      log("Error parsing song");
    } catch (e) {}
  }

  void handleSeek(double value) async {
    await player.seek(Duration(seconds: value.toInt()));
  }
  void handleSeekOld(double value) async {
    handleSeek(value);
  }

  void playerStateChange({String state = ""}) async {
    if (state == "prev") {
      await player.seek(Duration.zero);
    } else if (state == "pauseplay") {
      if (player.playing) {
        player.pause();
        _playerImageString = "assets/images/play-button.png";
      } else {
        player.play();
        _playerImageString = "assets/images/pause.png";
      }
      notifyListeners();
    }
  }
}
