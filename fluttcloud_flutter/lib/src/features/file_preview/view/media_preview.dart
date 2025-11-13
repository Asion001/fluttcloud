import 'package:chewie/chewie.dart';
import 'package:fluttcloud_flutter/fluttcloud_flutter.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaPreview extends StatefulWidget {
  const MediaPreview({required this.uri, super.key});
  final Uri uri;

  @override
  State<MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<MediaPreview> {
  late final ChewieController chewieController;
  late final VideoPlayerController videoPlayerController;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    if (loading) return;
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.networkUrl(widget.uri);
    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
    );

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: 16.circular),
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(minWidth: 300, minHeight: 300),
      margin: 16.all,
      child: loading
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator()],
            )
          : AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: Chewie(controller: chewieController),
            ),
    );
  }
}
