import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_nest/app_theme.dart';
import 'package:skill_nest/home/view/home_view.dart';
import 'package:skill_nest/home/view_model/home_view_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;
  const VideoPlayer({super.key, required this.videoUrl});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool isYouTube = false;
  bool isVimeo = false;
  YoutubePlayerController? youtubeController;
  VideoPlayerController? videoController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    isYouTube = widget.videoUrl.contains("youtube.com") ||
        widget.videoUrl.contains("youtu.be");
    isVimeo = widget.videoUrl.contains("vimeo.com");

    if (isYouTube) {
      final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl)!;
      youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          controlsVisibleAtStart: false,
          disableDragSeek: true,
          hideControls: true,
          enableCaption: false,
        ),
      )..addListener(() {
          setState(() {});
        });
    } else if (!isVimeo) {
      videoController = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          chewieController = ChewieController(
            videoPlayerController: videoController!,
            autoPlay: false,
            looping: false,
            showControls: false,
          );
          setState(() {});
        });
      videoController?.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    youtubeController?.dispose();
    videoController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  Widget buildLockedVideoPlayer() {
    if (isVimeo) {
      final vimeoRegExp = RegExp(r"vimeo\.com/(\d+)");
      final match = vimeoRegExp.firstMatch(widget.videoUrl);
      String videoId = match?.group(1) ?? '';

      return Stack(
        alignment: Alignment.center,
        children: [
          VimeoVideoPlayer(videoId: videoId),
          // Custom overlay buttons
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: buildCustomControls(), // Show same buttons
          ),
        ],
      );
    }

    return AbsorbPointer(
      absorbing: true,
      child: isYouTube
          ? YoutubePlayer(
              controller: youtubeController!,
              showVideoProgressIndicator: false,
            )
          : chewieController != null
              ? Chewie(controller: chewieController!)
              : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildProgressUI() {
    if (isVimeo) return const SizedBox(); // Vimeo plugin handles its own UI

    final current = isYouTube
        ? youtubeController!.value.position
        : videoController?.value.position ?? Duration.zero;

    final total = isYouTube
        ? youtubeController!.metadata.duration
        : videoController?.value.duration ?? Duration.zero;

    double progress = total.inMilliseconds == 0
        ? 0
        : current.inMilliseconds / total.inMilliseconds;

    String formatDuration(Duration d) {
      final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      return "$minutes:$seconds";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.blue),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "${formatDuration(current)} / ${formatDuration(total)}",
          style: const TextStyle(color: AppTheme.black, fontSize: 14),
        ),
      ],
    );
  }

  Widget buildCustomControls() {
    if (isVimeo) return const SizedBox(); // Vimeo plugin uses built-in controls

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          iconButton(Icons.replay_10, () {
            final pos = isYouTube
                ? youtubeController!.value.position
                : videoController!.value.position;
            seekTo(pos - const Duration(seconds: 10));
          }),
          iconButton(
            isPlaying() ? Icons.pause : Icons.play_arrow,
            () {
              if (isYouTube) {
                youtubeController!.value.isPlaying
                    ? youtubeController!.pause()
                    : youtubeController!.play();
              } else {
                videoController!.value.isPlaying
                    ? videoController!.pause()
                    : videoController!.play();
              }
              setState(() {});
            },
          ),
          iconButton(Icons.forward_10, () {
            final pos = isYouTube
                ? youtubeController!.value.position
                : videoController!.value.position;
            seekTo(pos + const Duration(seconds: 10));
          }),
        ],
      ),
    );
  }

  void seekTo(Duration newPosition) {
    if (isYouTube) {
      youtubeController!.seekTo(newPosition);
    } else {
      videoController!.seekTo(newPosition);
    }
  }

  bool isPlaying() {
    if (isYouTube) {
      return youtubeController!.value.isPlaying;
    } else {
      return videoController?.value.isPlaying ?? false;
    }
  }

  Widget iconButton(IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(15),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      child: Icon(icon, size: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeViewModel vm = context.watch<HomeViewModel>();
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        title: Text(
          "Unit ${vm.selectedModule.id}",
          style: const TextStyle(
            fontSize: 18,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: buildLockedVideoPlayer(),
            ),
            const SizedBox(height: 10),
            buildProgressUI(),
            const SizedBox(height: 10),
            buildCustomControls(),
            const SizedBox(height: 10),
            Text(
              vm.selectedVideo.title,
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              vm.selectedVideo.description,
              style: TextStyle(
                fontSize: 15,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: AppTheme.secondaryBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
