
import 'dart:ui';

import 'package:acvmx/core/app_provider.dart';
import 'package:acvmx/firebase_options.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_colors.dart';
import 'core/routes/routes.dart';
import 'core/sharedpreferences/sharedpreferences_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await availableCameras();
  await SharedPreferencesManager().init();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    MultiProvider(
      providers: appProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ACVMX',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColor.primaryWhite,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColor.primaryColor,
        ),
      ),
      routerConfig: routes,
    );
  }
}
