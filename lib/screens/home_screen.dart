import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/provider/music_list.dart';
import 'package:music_player/widgets/bottom_section.dart';
import 'package:music_player/widgets/current_playing.dart';
import 'package:music_player/widgets/home_card.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  final PageController ctrl = PageController(viewportFraction: 0.5);
  int currentPositon = 0;

  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);
    _checkAndRequestPermissions();

    ctrl.addListener(() {
      int pos = ctrl.page!.round();
      if (currentPositon != pos) {
        setState(() {
          currentPositon = pos;
        });
      }
    });
  }

  _checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(retryRequest: retry);
    _hasPermission ? setState(() {}) : null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && mounted) {
      _checkAndRequestPermissions();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ctrl.dispose();
    super.dispose();
  }

  Future<Uint8List?> getAlbumArt(id, type) async {
    final image = _audioQuery.queryArtwork(id, type);
    return image;
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
      body: !_hasPermission
          ? noAccessToLibraryWidget()
          : FutureBuilder<List<SongModel>>(
              future: _audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (ctx, item) {
                if (item.hasError) {
                  return Text(item.error.toString());
                }
                if (item.data == null) {
                  return const CircularProgressIndicator();
                }
                if (item.data!.isEmpty) {
                  return const Text('Nothing found');
                }
                print(item.data);
                getAlbumArt(item.data![0].id, ArtworkType.AUDIO)
                    .then((response) {
                  print(response);
                  print("printed");
                });
                return Container(
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
                            const SizedBox(
                              height: 100,
                            ),
                            const BottomSection()
                          ],
                        ),
                      ),
                      const Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 100,
                        child: CurrentPlaying(),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}
