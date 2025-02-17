import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/features/main/widget/navigation_bar/slider_bar.dart';
import 'package:vk_music/ui/widgets/common/audio_tile.dart';

import '../../../../widgets/common/media_cover.dart';
import 'audio_buttons.dart';

class AudioDetailBottomSheet extends StatelessWidget {
  const AudioDetailBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                onPressed: () => context.maybePop(),
              ),
            ),
          ),
          DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 80,
                child: const TabBarView(
                  children: [_MainBody(), _MusicList()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainBody extends StatelessWidget {
  const _MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    return ValueListenableBuilder(
      valueListenable: player.currentAudioNotifier,
      builder: (context, audio, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CoverWidget(
                photoUrl: audio!.album?.thumb?.photo600,
                size: MediaQuery.of(context).size.width - 50,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
              child: SliderBar(),
            ),
            const Spacer(),
            Text(
              audio.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, overflow: TextOverflow.ellipsis),
            ),
            Text(player.currentAudioNotifier.value!.artist, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MusicBarPreviousAudioButton(size: 48),
                MusicBarPlayButton(size: 48),
                MusicBarNextAudioButton(size: 48)
              ],
            ),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ShuffleButton(), LoopModeButton()],
            )
          ],
        );
      },
    );
  }
}

class _MusicList extends StatelessWidget {
  const _MusicList({super.key});

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ValueListenableBuilder(
            valueListenable: player.currentPlaylist,
            builder: (context, playlist, _) {
              return SliverReorderableList(
                itemCount: playlist!.length,
                itemBuilder: (context, index) {
                  return ReorderableDelayedDragStartListener(
                    key: ValueKey(index),
                    index: index,
                    child: AudioTile(
                      audio: player.shuffleModeEnabled
                          ? playlist.children[playlist.shuffleIndices[index]] as PlayerAudio
                          : playlist.children[index] as PlayerAudio,
                      playlist: playlist,
                      withMenu: true,
                    ),
                  );
                },
                onReorder: (currentIndex, newIndex) {
                  if (player.shuffleModeEnabled) {
                    player.moveShuffle(currentIndex, newIndex);
                    return;
                  }
                  player.move(currentIndex, newIndex);
                },
                proxyDecorator: _proxyDecorator,
              );
            },
          ),
        ],
      ),
    );
  }
}
