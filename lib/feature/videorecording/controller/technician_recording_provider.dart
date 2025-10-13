import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';

// class TechnicianCameraProvider extends ChangeNotifier {
//   late CameraController controller;
//   List<CameraDescription> _cameras = [];
//   bool isInitialized = false;
//   bool isRecording = false;
//   bool isFlashOn = false;
//   Timer? _timer;
//   int _seconds = 0;
//
//   String? recordedVideoPath; // ✅ new
//
//   String get recordingDuration {
//     final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
//     final seconds = (_seconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }
//
//   Future<void> init() async {
//     await Permission.camera.request();
//     await Permission.microphone.request();
//     _cameras = await availableCameras();
//     controller = CameraController(_cameras[0], ResolutionPreset.high);
//     await controller.initialize();
//     isInitialized = true;
//     notifyListeners();
//   }
//
//   Future<void> startRecording() async {
//     await controller.startVideoRecording();
//     isRecording = true;
//     recordedVideoPath = null; // Clear previous video
//     _startTimer();
//     notifyListeners();
//   }
//
//   Future<void> stopRecording(BuildContext context) async {
//     final XFile file = await controller.stopVideoRecording();
//     isRecording = false;
//     _stopTimer();
//     recordedVideoPath = file.path; // Save file path
//     notifyListeners();
//
//     try {
//       final downloadsDirectory = Directory('/storage/emulated/0/Download');
//       if (!downloadsDirectory.existsSync()) {
//         downloadsDirectory.createSync(recursive: true);
//       }
//
//       final newFilePath = path.join(
//         downloadsDirectory.path,
//         'ACVMX_TECHNICIAN_${DateTime.now().millisecondsSinceEpoch}.mp4',
//       );
//
//       final newFile = await File(file.path).copy(newFilePath);
//       recordedVideoPath = newFile.path; // Save new copied path
// if(context.mounted) {
//   ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Video saved to Downloads: ${newFile.path}")),
//       );
// }
//     } catch (e) {
//       if(context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to save video: $e")),
//       );
//       }
//     }
//   }
//
//   void toggleFlash() async {
//     if (controller.value.flashMode == FlashMode.torch) {
//       await controller.setFlashMode(FlashMode.off);
//       isFlashOn = false;
//     } else {
//       await controller.setFlashMode(FlashMode.torch);
//       isFlashOn = true;
//     }
//     notifyListeners();
//   }
//
//   void _startTimer() {
//     _seconds = 0;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       _seconds++;
//       notifyListeners();
//     });
//   }
//
//   void _stopTimer() {
//     _timer?.cancel();
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }
// }



class TechnicianCameraProvider extends ChangeNotifier {
  late CameraController controller;
  bool isInitialized = false;
  bool isRecording = false;
  bool isFlashOn = false;
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  Timer? _timer;
  int _seconds = 0;

  String? recordedVideoPath;
  String? thumbnailPath;

  String get recordingDuration {
    final remaining = 30 - _seconds;
    final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (remaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<bool> init(BuildContext context) async {
    final camPermission = await _checkAndRequestPermission(Permission.camera, context);
    final micPermission = await _checkAndRequestPermission(Permission.microphone, context);

    if (!camPermission || !micPermission) {
      isInitialized = false;
      notifyListeners();
      return false;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        isInitialized = false;
        notifyListeners();
        return false;
      }

      controller = CameraController(cameras.first, ResolutionPreset.high);
      await controller.initialize();
      isInitialized = true;
      notifyListeners();
      return true;
    } catch (e) {
      isInitialized = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> startRecording() async {
    if (!isInitialized || isRecording) return;

    try {
      await controller.startVideoRecording();
      isRecording = true;
      recordedVideoPath = null;
      thumbnailPath = null;
      _startTimer();
      notifyListeners();
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }


  Future<void> stopRecording() async {
    if (!isRecording || controller == null) return;

    try {
      _isProcessing = true;
      notifyListeners();

      final XFile rawVideo = await controller.stopVideoRecording();
      isRecording = false;
      _stopTimer();
      notifyListeners();
      await VideoCompress.setLogLevel(0);

      final MediaInfo? compressedInfo = await VideoCompress.compressVideo(
        rawVideo.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: true,
      );

      if (compressedInfo == null || compressedInfo.path == null) {
        debugPrint('Video compression failed or returned no path.');
        recordedVideoPath = null;
        thumbnailPath = null;
        _isProcessing = false;
        notifyListeners();
        return;
      }

      final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      final String acvmxDirPath = path.join(appDocumentsDir.path, 'ACVMX');
      final Directory acvmxDir = Directory(acvmxDirPath);

      if (!await acvmxDir.exists()) {
        await acvmxDir.create(recursive: true);
      }

      final String videoFileName = 'ACVMX-${DateTime.now().millisecondsSinceEpoch}.mp4';
      final String finalVideoPathInACVMX = path.join(acvmxDirPath, videoFileName);

      File compressedFileFromPlugin = File(compressedInfo.path!);
      File savedVideoFile = await compressedFileFromPlugin.copy(finalVideoPathInACVMX);

      if (await compressedFileFromPlugin.exists()) {
        await compressedFileFromPlugin.delete();
      }

      recordedVideoPath = savedVideoFile.path;

      // Generate thumbnail
      if (recordedVideoPath != null) {
        final File sourceThumbnailFile = await VideoCompress.getFileThumbnail(
          recordedVideoPath!,
          quality: 75,
          position: -1,
        );

        final String thumbnailsDirPath = path.join(acvmxDirPath, 'Thumbnails');
        final Directory thumbnailsDir = Directory(thumbnailsDirPath);
        if (!await thumbnailsDir.exists()) {
          await thumbnailsDir.create(recursive: true);
        }

        final String thumbFileName = 'THUMB_${path.basenameWithoutExtension(recordedVideoPath!)}.jpg';
        final String finalThumbPath = path.join(thumbnailsDirPath, thumbFileName);

        File finalThumbnailFile = await sourceThumbnailFile.copy(finalThumbPath);
        thumbnailPath = finalThumbnailFile.path;

        if (sourceThumbnailFile.path != finalThumbnailFile.path && await sourceThumbnailFile.exists()) {
          await sourceThumbnailFile.delete();
        }
      }

    } catch (e) {
      debugPrint('Error stopping/processing recording: $e');
      isRecording = false;
      recordedVideoPath = null;
      thumbnailPath = null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
  Future<bool> _checkAndRequestPermission(Permission permission, BuildContext context) async {
    var status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied || status.isPermanentlyDenied) {
      final result = await permission.request();
      if (result.isGranted) return true;

      if (result.isPermanentlyDenied) {
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Permission Required'),
              content: const Text(
                  'Please enable the permission from app settings to use this feature.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          );
        }
      }
    }

    return false;
  }

  void toggleFlash() async {
    if (!isInitialized) return;

    try {
      isFlashOn = !isFlashOn;
      await controller.setFlashMode(isFlashOn ? FlashMode.torch : FlashMode.off);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  void _startTimer() {
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      notifyListeners();
      if (_seconds >= 30) {
        stopRecording();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> clearCache() async {
    try {
      await VideoCompress.deleteAllCache();
      recordedVideoPath = null;
      thumbnailPath = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _stopTimer();
    VideoCompress.dispose();
    super.dispose();
  }
}

