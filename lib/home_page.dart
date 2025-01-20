import 'package:flutter/material.dart';
import 'package:music_player/audio_list.dart';
import 'package:music_player/request_permission.dart';
import 'package:provider/provider.dart';

import 'homepage_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var provider = Provider.of<HompageProvider>(context, listen: false);
      provider.setMusic();
    });
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HompageProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<Duration>(
                stream: provider.player.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = provider.player.duration;
                  Duration result = Duration.zero;
                  if (duration != null) {
                    result = duration - position;
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(position.toString().substring(0, 7)),
                          Text(result.toString().substring(0, 7)),
                        ],
                      ),
                      Slider(
                        value: position.inSeconds.toDouble(),
                        min: 0.0,
                        max: provider.playerDuration,
                        onChanged: (double value) => provider.handleSeek(value),
                      ),
                    ],
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                playerIcons(context, "assets/images/next-button.png",
                    reverse: true,
                    onTap: () => provider.playerStateChange(state: "prev")),
                Consumer<HompageProvider>(builder: (context, player, _) {
                  return playerIcons(
                    context,
                    player.playerImageString,
                    onTap: () => player.playerStateChange(state: "pauseplay"),
                  );
                }),
                playerIcons(
                  context,
                  "assets/images/next-button.png",
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              _createRoute(),
            );
          },
          child: Text("list")),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AudioList(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Widget playerIcons(BuildContext context, String assetString,
    {bool reverse = false, required GestureTapCallback onTap}) {
  var size = MediaQuery.of(context).size;
  return GestureDetector(
    onTap: onTap,
    child: RotatedBox(
      quarterTurns: reverse ? 2 : 0,
      child: Image.asset(
        assetString,
        width: size.width * 0.12,
        height: size.height * 0.12,
      ),
    ),
  );
}
