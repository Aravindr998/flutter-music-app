import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/provider/music_list.dart';
import 'package:music_player/widgets/song_item.dart';

class BottomSection extends ConsumerStatefulWidget {
  const BottomSection({super.key});

  @override
  ConsumerState<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends ConsumerState<BottomSection> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> recentList = [];
    final List<Widget> favouritesList = [];
    final songs = ref.watch(musicListProvider);
    for (var i = 0; i < songs.length; i++) {
      recentList.add(SongItem(song: songs[i]));
      recentList.add(const SizedBox(
        height: 20,
      ));
    }
    return Expanded(
      child: Row(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'Recents',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'Favourites',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 119, 119, 119),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...recentList,
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
