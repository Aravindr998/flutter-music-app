import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/provider/music_list.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with WidgetsBindingObserver {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);
    if (_hasPermission) {
      print("in true of hasperm");
      ref.read(musicListProvider.notifier).loadSongs();
    } else {
      print("in false of hasperm");
      _checkAndRequestPermissions();
    }
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
  Widget build(BuildContext context) {
    ref.read(musicListProvider.notifier).loadSongs();
    return const Scaffold(
      body: Center(
        child: Text('Splash screen'),
      ),
    );
  }
}
