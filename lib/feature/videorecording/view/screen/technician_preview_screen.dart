import 'dart:io';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/Ticket/view/screen/add_attachment.dart';
import 'package:acvmx/feature/videorecording/controller/technician_recording_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';



import '../../../../core/app_colors.dart';
import '../../../../core/custom_text.dart';
import '../../../Dashboard/view/widgets/appbar.dart';
import '../../../Ticket/controller/ticket_details_byId_controller.dart';

/// ChangeNotifier that manages VideoPlayerController logic
class TechnicianPreviewNotifier extends ChangeNotifier {
  final String videoPath;
  late final VideoPlayerController controller;

  TechnicianPreviewNotifier(this.videoPath);

  void initialize() {
    controller = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        notifyListeners();
        controller.play();
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

  void confirmVideo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AttachmentScreen(videoPath: videoPath,),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

/// StatelessWidget that provides the notifier
class TechnicianPreviewScreen extends StatelessWidget {
  final String videoPath;
  const TechnicianPreviewScreen({super.key, required this.videoPath});

  @override
  Widget build(BuildContext context) {
    final setVideoPath = context.read<TicketDetailsController>();
    return ChangeNotifierProvider<TechnicianPreviewNotifier>(
      create: (_) {
        final notifier = TechnicianPreviewNotifier(videoPath);
        notifier.initialize();
        return notifier;
      },
      child: Scaffold(
        appBar: commonAppBar(
          context,
          title: 'Preview Video',
          showLeading: true,
          onBack: () {
            final notifier = context.read<TechnicianPreviewNotifier>();
            context.read<TechnicianCameraProvider>().clearCache();
            notifier.dispose();

            Navigator.of(context).pop();

          },
        ),
        body: Consumer<TechnicianPreviewNotifier>(
          builder: (context, notifier, _) {
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
                        GestureDetector(
                          onTap: notifier.togglePlayPause,
                          child: CircleAvatar(
                            backgroundColor: Colors.black45,
                            radius: 30,
                            child: Icon(
                              notifier.isPlaying ? Icons.pause : Icons.play_arrow,
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

                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          IconButton(onPressed: (){
                            context.read<TechnicianCameraProvider>().clearCache();
                            GoRouter.of(context).pop();
                          },  icon: Icon(Icons.delete, size: 60, color: AppColor.statusRed),),
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
                            onPressed: (){
                              setVideoPath.setVideoPath(videoPath);
                              notifier.confirmVideo(context);
                            },
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
        )
      ),
    );
  }
}
