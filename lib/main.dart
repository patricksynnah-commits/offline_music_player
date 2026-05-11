import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MusicHome(),
    );
  }
}

class MusicHome extends StatefulWidget {
  const MusicHome({super.key});

  @override
  State<MusicHome> createState() => _MusicHomeState();
}

class _MusicHomeState extends State<MusicHome> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer player = AudioPlayer();

  List<SongModel> songs = [];

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    await Permission.storage.request();

    songs = await audioQuery.querySongs();

    setState(() {});
  }

  void playSong(String path) async {
    await player.setFilePath(path);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offline Music Player"),
      ),
      body: songs.isEmpty
          ? const Center(
              child: Text("No Songs Found"),
            )
          : ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(songs[index].title),
                  subtitle: Text(
                    songs[index].artist ?? "Unknown Artist",
                  ),
                  onTap: () {
                    playSong(songs[index].data);
                  },
                );
              },
            ),
    );
  }
}
