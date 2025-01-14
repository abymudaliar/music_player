import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              playerIcons(
                context,
                "assets/images/next-button.png",
                reverse: true,
                onTap: () {},
              ),
              playerIcons(
                context,
                "assets/images/play-button.png",
                onTap: () {},
              ),
              playerIcons(
                context,
                "assets/images/next-button.png",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
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
        width: size.width * 0.15,
        height: size.height * 0.15,
      ),
    ),
  );
}
