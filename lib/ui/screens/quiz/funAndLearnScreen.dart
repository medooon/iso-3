import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterquiz/app/app_localization.dart';
import 'package:flutterquiz/app/routes.dart';
import 'package:flutterquiz/features/quiz/models/comprehension.dart';
import 'package:flutterquiz/features/quiz/models/quizType.dart';
import 'package:flutterquiz/ui/widgets/customAppbar.dart';
import 'package:flutterquiz/utils/constants/fonts.dart';
import 'package:flutterquiz/utils/constants/string_labels.dart';
import 'package:flutterquiz/utils/ui_utils.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:ios_insecure_screen_detector/ios_insecure_screen_detector.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class FunAndLearnScreen extends StatefulWidget {
  final QuizTypes quizType;
  final Comprehension comprehension;

  const FunAndLearnScreen({
    Key? key,
    required this.quizType,
    required this.comprehension,
  }) : super(key: key);

  @override
  State<FunAndLearnScreen> createState() => _FunAndLearnScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    Map? arguments = routeSettings.arguments as Map?;
    return CupertinoPageRoute(
      builder: (_) => FunAndLearnScreen(
        quizType: arguments!['quizType'] as QuizTypes,
        comprehension: arguments['comprehension'] as Comprehension,
      ),
    );
  }
}

class _FunAndLearnScreenState extends State<FunAndLearnScreen> with WidgetsBindingObserver {
  IosInsecureScreenDetector? _iosInsecureScreenDetector;
  late bool isScreenRecordingInIos = false;

  @override
  void initState() {
    super.initState();

    // Prevent the screen from locking
    WakelockPlus.enable();

    // Prevent screenshots and screen recordings
    if (Platform.isIOS) {
      initScreenshotAndScreenRecordDetectorInIos();
    } else {
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  void initScreenshotAndScreenRecordDetectorInIos() async {
    _iosInsecureScreenDetector = IosInsecureScreenDetector();
    await _iosInsecureScreenDetector?.initialize();
    _iosInsecureScreenDetector?.addListener(iosScreenshotCallback, iosScreenRecordCallback);
  }

  void iosScreenshotCallback() {
    print("User took screenshot");
    // Implement your logic for handling screenshots
  }

  void iosScreenRecordCallback(bool isRecording) {
    setState(() => isScreenRecordingInIos = isRecording);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    WakelockPlus.disable();
    _iosInsecureScreenDetector?.dispose();
    if (Platform.isAndroid) {
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
    super.dispose();
  }

  Widget _buildParagraph() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * UiUtils.hzMarginPct,
      ),
      child: SingleChildScrollView(
        child: Html(
          style: {
            "body": Style(
              color: Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeights.regular,
              fontSize: FontSize(18),
            )
          },
          data: widget.comprehension.detail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QAppBar(
        roundedAppBar: false,
        title: Text(widget.comprehension.title!),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: _buildParagraph(),
      ),
    );
  }
}
