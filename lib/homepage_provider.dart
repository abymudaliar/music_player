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

    void handleSeek(double value) async {
      await player.seek(Duration(seconds: value.toInt()));
    }

    void playerStateChange({String state = ""}) async {
      if(state == "prev"){
        await player.seek(Duration.zero);
      }
      else if(state == "pauseplay"){
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
}