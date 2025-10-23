import 'dart:io';
import 'package:acvmx/core/app_colors.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/core/routes/route_name.dart';
import 'package:acvmx/feature/videorecording/controller/customer_recording_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/custom_text.dart';
import '../../../Dashboard/view/widgets/appbar.dart';

/// ChangeNotifier that wraps your VideoPlayerController
class VideoPreviewNotifier extends ChangeNotifier {
  final String videoPath;
  late final VideoPlayerController controller;

  VideoPreviewNotifier(this.videoPath);

  /// Call right after creation
  void initialize() {
    controller = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        notifyListeners();    // re‑build when ready
        controller.play();    // auto‑play
      });
  }

  bool get isInitialized => controller.value.isInitialized;
  bool get isPlaying     => controller.value.isPlaying;

  void togglePlayPause() {
    if (isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    notifyListeners();
  }

  void confirmVideo(BuildContext context,String location) {
    context.pushReplacementNamed(
      RouteName.raiseTicketScreen,
      extra: {
        'videoPath': videoPath,
        'location': location,
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

/// Top‑level screen: now Stateless, provides the notifier
class CustomerPreviewScreen extends StatelessWidget {
  final String videoPath;
  final String location;
  const CustomerPreviewScreen({super.key, required this.videoPath,required this.location});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoPreviewNotifier>(
      create: (_) {
        final notifier = VideoPreviewNotifier(videoPath);
        notifier.initialize();
        return notifier;
      },
      child: Scaffold(
        appBar: commonAppBar(
          context,
          title: 'Preview Video',
          onBack: () {
            context.read<CustomerCameraProvider>().clearCache();
            GoRouter.of(context).pop();
          },
        ),
        body: _CustomerPreviewBody(location),
      ),
    );
  }
}

/// Actual UI, rebuilt via Provider + Consumer
class _CustomerPreviewBody extends StatelessWidget {
   _CustomerPreviewBody(this.location);
  final String location;

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPreviewNotifier>(
      builder: (context, notifier, _) {
        print('Video preview Path : ${notifier.videoPath}');
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (notifier.isInitialized)
              AspectRatio(
                aspectRatio: 4 / 5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(notifier.controller),

                    // Play/Pause overlay
                    GestureDetector(
                      onTap: notifier.togglePlayPause,
                      child: CircleAvatar(
                        backgroundColor: Colors.black45,
                        radius: 30,
                        child: Icon(
                          notifier.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: AppColor.primaryWhite,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Center(child: const CircularProgressIndicator()),

            30.height,

            // Confirm Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      IconButton(onPressed: (){
                        context.read<CustomerCameraProvider>().clearCache();
                        GoRouter.of(context).pop();
                      },  icon: Icon(Icons.delete, size: 60, color: AppColor.statusRed),
                      ),
                      CustomText(
                        text: "Delete",
                        fontSize: 14,
                        color: AppColor.blackColor,
                        fontWeight: AppFontWeight.w600,
                      )
                    ],
                  ),
                ),
                40.width,
                Center(
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.check_circle,
                          size: 60,
                          color: AppColor.statusGreen,
                        ),
                        onPressed: () => notifier.confirmVideo(context,location),
                      ),
                      CustomText(
                        text: "Submit",
                        fontSize: 14,
                        color: AppColor.blackColor,
                        fontWeight: AppFontWeight.w600,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}