import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/provider/music_list.dart';
import 'package:music_player/widgets/home_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController ctrl = PageController(viewportFraction: 0.5);
  int currentPositon = 0;

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() {
      int pos = ctrl.page!.round();
      if (currentPositon != pos) {
        setState(() {
          currentPositon = pos;
        });
      }
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const linearTextGradient = LinearGradient(colors: [
      Color.fromARGB(255, 81, 0, 255),
      Color.fromARGB(255, 166, 0, 255),
      Color.fromARGB(255, 78, 0, 246)
    ]);
    final songs = ref.watch(musicListProvider);
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => linearTextGradient.createShader(
            Rect.fromLTWH(
              0,
              0,
              bounds.width,
              bounds.height,
            ),
          ),
          child: const Text(
            "Discover",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color.fromARGB(255, 229, 165, 160),
              Colors.white
            ],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Your songs',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 200,
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: ctrl,
                            itemCount: songs.length,
                            itemBuilder: (ctx, index) => HomeCard(
                              song: songs[index],
                              active: currentPositon == index,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
