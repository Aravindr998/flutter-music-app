import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.song,
    required this.active,
  });

  final Song song;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final double top = active ? 0 : 10;
    final double bottom = active ? 0 : 10;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(
        top: top,
        bottom: bottom,
        right: 10,
      ),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Image.asset(
              song.albumCover,
              width: double.infinity,
              height: double.infinity,
              // width: 160,
              // height: active ? 200 : 180,
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }
}
