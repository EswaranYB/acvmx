import 'package:acvmx/core/app_assets.dart';
import 'package:acvmx/core/responsive.dart';
import 'package:acvmx/feature/Dashboard/view/widgets/appbar.dart';
import 'package:acvmx/feature/videorecording/view/screen/technician_preview_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/custom_text.dart';
import '../../controller/technician_recording_provider.dart';


class TechnicianRecordingScreen extends StatelessWidget {
  const TechnicianRecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TechnicianCameraProvider()..init(context),
      child: Consumer<TechnicianCameraProvider>(
        builder: (context, cameraProvider, _) {
          if (!cameraProvider.isInitialized) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            appBar: commonAppBar(context,showLeading: true),
            body: Stack(
              children: [
                CameraPreview(cameraProvider.controller),

                // Custom Top Bar
                Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColor.blackColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (cameraProvider.isRecording) ...[
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: AppColor.statusRed,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              5.width,
                              CustomText(
                                text: "Rec",
                                fontSize: 14,
                                color: AppColor.primaryWhite,
                                fontWeight: AppFontWeight.w600,
                              ),
                            ]
                          ],
                        ),
                        CustomText(
                          text: cameraProvider.recordingDuration,
                          fontSize: AppFontSize.s14,
                          color: AppColor.primaryWhite,
                          fontWeight: AppFontWeight.w600,
                        ),
                        IconButton(
                          onPressed: cameraProvider.toggleFlash,
                          icon: Icon(
                            cameraProvider.isFlashOn
                                ? Icons.flash_on
                                : Icons.flash_off,
                            color: AppColor.primaryWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Capture Button Bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 50),
                    child:cameraProvider.isProcessing? CustomText(
                      text: "Please wait moment...",
                      fontSize: 16,
                      color: AppColor.primaryWhite,
                      fontWeight: AppFontWeight.w600,
                    ):
                    Row(
                      mainAxisAlignment: cameraProvider.recordedVideoPath != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  AppColor.statusRed,
                                  BlendMode.srcIn,
                                ),
                                child: SvgPicture.asset(
                                  cameraProvider.isRecording
                                      ? AppIcons.capturepauseicon
                                      : AppIcons.captureicon,
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                              onPressed: cameraProvider.isRecording
                                  ? () => cameraProvider.stopRecording()
                                  : cameraProvider.startRecording,
                            ),
                            if (cameraProvider.recordedVideoPath != null)...[
                              CustomText(
                                text: "Back to Recording",
                                fontSize: 14,
                                color: AppColor.primaryWhite,
                                fontWeight: AppFontWeight.w600,
                              )
                            ]else...[
                              CustomText(
                                text: cameraProvider.isRecording
                                    ? "Stop Recording"
                                    : "Start Recording",
                                fontSize: 16,
                                color: AppColor.primaryWhite,
                                fontWeight: AppFontWeight.w600,
                              )
                            ]
                          ],
                        ),
                        20.width,
                        if (cameraProvider.recordedVideoPath != null)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(bottom: 20),
                                icon: Icon(Icons.arrow_circle_right_rounded,
                                    size: 60, color: AppColor.statusGreen),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TechnicianPreviewScreen(
                                        videoPath: cameraProvider.recordedVideoPath!,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              CustomText(
                                text: "Preview",
                                fontSize: 14,
                                color: AppColor.primaryWhite,
                                fontWeight: AppFontWeight.w600,
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
