import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_player/models/song.dart';

class SongItem extends StatelessWidget {
  const SongItem({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.hardEdge,
          child: Image.memory(
            song.albumCover,
            width: 50,
            height: 50,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                song.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              Text(
                song.artist,
                style: const TextStyle(
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz),
        )
      ],
    );
  }
}
