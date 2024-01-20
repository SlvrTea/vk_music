
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/state/music_player/music_player_bloc.dart';

import '../../data/vk_api/vk_music.dart';

class PlayIcon extends StatelessWidget {
  const PlayIcon(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MusicPlayerBloc>();
    return bloc.musicPlayer.player.playing ? const Icon(Icons.pause_rounded, size: 32) : const Icon(Icons.play_arrow_rounded, size: 32);
  }
}
