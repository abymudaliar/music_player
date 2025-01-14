import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HompageProvider extends ChangeNotifier{


    final player = AudioPlayer();
    String _playerImageString = "assets/images/play-button.png";
    String get playerImageString => _playerImageString;
    double _playerDuration = 0.0;
    double get playerDuration => _playerDuration;


    void setMusic() async {
      await player.setAsset("assets/audio/spinning-head.mp3");
      _playerDuration = player.duration?.inSeconds.toDouble() ?? 0.0;
    }

    void playerStateChange(){
      if(player.playing){
        player.pause();
        _playerImageString = "assets/images/play-button.png";
      }
      else{
        player.play();
        _playerImageString = "assets/images/pause.png";
      }
      notifyListeners();
    }
}