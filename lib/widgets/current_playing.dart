import 'package:flutter/material.dart';

class CurrentPlaying extends StatefulWidget {
  const CurrentPlaying({super.key});

  @override
  State<CurrentPlaying> createState() => _CurrentPlayingState();
}

class _CurrentPlayingState extends State<CurrentPlaying> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 244, 155, 149),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              'assets/images/beatles.jpg',
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
