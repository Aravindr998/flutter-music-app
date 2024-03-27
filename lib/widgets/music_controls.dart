import 'package:flutter/material.dart';

class MusicControls extends StatefulWidget {
  const MusicControls({super.key});

  @override
  State<MusicControls> createState() => _MusicControlsState();
}

class _MusicControlsState extends State<MusicControls> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.skip_previous_rounded,
              size: 50,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.play_arrow_rounded,
              size: 50,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.skip_next_rounded,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
