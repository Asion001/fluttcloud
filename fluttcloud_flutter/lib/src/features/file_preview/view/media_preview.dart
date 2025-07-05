import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:fluttcloud_flutter/fluttcloud_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
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
  File? _tmpFile;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    if (_tmpFile != null && _tmpFile!.existsSync()) {
      _tmpFile!.deleteSync();
    }
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    // Fixes loading media without file extension
    final desktopPlatform =
        !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
    if (desktopPlatform) {
      _tmpFile = File(
        [
          (await getTemporaryDirectory()).path,
          basename(widget.uri.path),
        ].join(Platform.pathSeparator),
      );
      await Dio().downloadUri(widget.uri, _tmpFile!.path);
      videoPlayerController = VideoPlayerController.file(_tmpFile!);
    } else {
      videoPlayerController = VideoPlayerController.networkUrl(widget.uri);
    }

    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
    );

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: 16.circular),
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(minWidth: 300, minHeight: 300),
      margin: 16.all,
      child: loading
          ? const CircularProgressIndicator()
          : AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: Chewie(controller: chewieController),
            ),
    );
  }
}
