import 'dart:typed_data';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Song {
  Song(
      {required this.path,
      required this.title,
      required this.artist,
      required this.albumCover,
      String? id})
      : id = id ?? uuid.v4();
  final String id;
  final String path;
  final String title;
  final String artist;
  final Uint8List albumCover;
}
