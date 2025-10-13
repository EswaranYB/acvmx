// video_player_screen.dart

import 'package:acvmx/core/app_decoration.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key,required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    }).catchError((error){
      print("Video initialization error: $error");
      showSnackBar(context,"Failed to load video");
    });

    _controller.addListener(() {
      final error = _controller.value.errorDescription;
      if(error != null){
        // showSnackBar(context, "Playback error: $error");
      }
      setState(() {}); // Updates UI on status change
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _rewind() {
    final newPosition = _controller.value.position - const Duration(seconds: 10);
    _controller.seekTo(newPosition >= Duration.zero ? newPosition : Duration.zero);
  }

  void _forward() {
    final newPosition = _controller.value.position + const Duration(seconds: 10);
    final duration = _controller.value.duration;
    _controller.seekTo(newPosition <= duration ? newPosition : duration);
  }

  @override
  Widget build(BuildContext context) {
    print('Video URL: ${widget.videoUrl}');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Video Playback'),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        VideoPlayer(_controller),
                        VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: Colors.blue,
                            backgroundColor: Colors.white24,
                            bufferedColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.replay_10, color: Colors.white),
                        iconSize: 32,
                        onPressed: _rewind,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        iconSize: 40,
                        onPressed: _togglePlayback,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.forward_10, color: Colors.white),
                        iconSize: 32,
                        onPressed: _forward,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    // final twoDigits = (int n) => n.toString().padLeft(2, '0');
    twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }
}



// class BetterVideoPlayerScreen extends StatelessWidget {
//   final String videoUrl;
//
//   const BetterVideoPlayerScreen({super.key, required this.videoUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     BetterPlayerDataSource dataSource = BetterPlayerDataSource(
//       BetterPlayerDataSourceType.network,
//       videoUrl,
//       useAsmsSubtitles: false,
//     );
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text('Better Player'),
//       ),
//       body: BetterPlayer(
//         controller: BetterPlayerController(
//           BetterPlayerConfiguration(
//             aspectRatio: 16 / 9,
//             autoPlay: true,
//             looping: false,
//             controlsConfiguration: const BetterPlayerControlsConfiguration(
//               enableSkips: true,
//             ),
//           ),
//         )..setupDataSource(dataSource),
//       ),
//     );
//   }
// }




// class VideoProvider extends ChangeNotifier {
//   String _videoUrl = 'https://acvmx.coderzbot.com/admin/admin/uploads/tickets/ACVMX_CUSTOMER_1748237788118.mp4';
//   String get videoUrl => _videoUrl;
//
//   void setVideoUrl(String url) {
//     _videoUrl = url;
//     notifyListeners();
//   }
// }