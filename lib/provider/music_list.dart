import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/models/song.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'musicList.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE music_list(id TEXT PRIMARY KEY, title TEXT, albumCover TEXT, path TEXT, artist TEXT)');
    },
    version: 1,
  );
  return db;
}

class MusicListNotifier extends StateNotifier<List<Song>> {
  MusicListNotifier() : super(const []);

  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<Uint8List?> _getAlbumArt(id, type) async {
    final image = _audioQuery.queryArtwork(id, type);
    return image;
  }

  Future<void> loadSongs() async {
    final db = await _getDataBase();
    final data = await db.query('music_list');
    List<Song> songs = [];
    for (var i = 0; i < data.length; i++) {
      final row = data[i];
      if ((row['albumCover'] as String).isNotEmpty) {}
      final albumCoverFile =
          await File(row['albumCover'] as String).readAsBytes();
      songs.add(Song(
        id: row['id'] as String,
        path: row['path'] as String,
        title: row['title'] as String,
        artist: row['artist'] as String,
        albumCover: albumCoverFile,
      ));
    }
    if (songs.isEmpty) {
      print("isempty");
      final queriedSongs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      List<Song> songWithAlbumArt = [];
      for (var i = 0; i < queriedSongs.length; i++) {
        String albumArtPath = '';
        Uint8List? image;
        SongModel item = queriedSongs[i];
        image = await _getAlbumArt(item.id, ArtworkType.AUDIO);
        if (image != null || image!.isNotEmpty) {
          final path = (await getApplicationDocumentsDirectory()).path;
          print(path);
          final imageName = '${item.id}.png';
          final newImage = File('$path/$imageName');
          await newImage.writeAsBytes(image);
          albumArtPath = '$path/$imageName';
        }

        songWithAlbumArt.add(
          Song(
            path: item.uri ?? "",
            title: item.title,
            artist: item.artist ?? "Unknown artist",
            albumCover: image,
          ),
        );
      }
      songs = songWithAlbumArt;
    }
    state = songs;
  }

  Future<void> setSongs(List<Map<String, dynamic>> songList) async {
    final songs = songList
        .map(
          (item) => Song(
            id: item['song'].id.toString(),
            artist: item['song'].artist ?? 'unknown artist',
            path: item['song'].uri!,
            title: item['song'].title,
            albumCover: item['albumArtPath'],
          ),
        )
        .toList();
    final db = await _getDataBase();
    for (var i = 0; i < songs.length; i++) {
      Song songItem = songs[i];
      db.insert('music_list', {
        'id': songItem.id,
        'path': songItem.path,
        'title': songItem.title,
        'artist': songItem.artist,
        'albumCover': songItem.albumCover,
      });
    }
    state = [...songs, ...state];
  }
}

final musicListProvider = StateNotifierProvider<MusicListNotifier, List<Song>>(
  (ref) => MusicListNotifier(),
);
