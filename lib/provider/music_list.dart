import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/data/dummy_data.dart';

final musicListProvider = Provider((ref) => dummySongs);
