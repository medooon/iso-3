import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterquiz/app/app_localization.dart';
import 'package:flutterquiz/app/routes.dart';
import 'package:flutterquiz/features/quiz/models/comprehension.dart';
import 'package:flutterquiz/features/quiz/models/quizType.dart';
import 'package:flutterquiz/ui/widgets/customAppbar.dart';
import 'package:flutterquiz/ui/widgets/customRoundedButton.dart';
import 'package:flutterquiz/utils/constants/fonts.dart';
import 'package:flutterquiz/utils/constants/string_labels.dart';
import 'package:flutterquiz/utils/ui_utils.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:ios_insecure_screen_detector/ios_insecure_screen_detector.dart';
import 'dart:io' show Platform;


class FunAndLearnScreen extends StatefulWidget {
  final QuizTypes quizType;
  final Comprehension comprehension;

  const FunAndLearnScreen({
    super.key,
    required this.quizType,
    required this.comprehension,
  });

  @override
  State<FunAndLearnScreen> createState() => _FunAndLearnScreen();

  static Route<dynamic> route(RouteSettings routeSettings) {
    Map? arguments = routeSettings.arguments as Map?;
    return CupertinoPageRoute(
      builder: (_) => FunAndLearnScreen(
        quizType: arguments!['quizType'] as QuizTypes,
        comprehension: arguments['comprehension'],
      ),
    );
  }
}

class _FunAndLearnScreen extends State<FunAndLearnScreen>
    with TickerProviderStateMixin {
  final double topPartHeightPercentage = 0.275;
  final double userDetailsHeightPercentage = 0.115;

  void navigateToQuestionScreen() {
    Navigator.of(context).pushReplacementNamed(Routes.quiz, arguments: {
      "numberOfPlayer": 1,
      "quizType": QuizTypes.funAndLearn,
      "comprehension": widget.comprehension,
      "quizName": "Fun 'N'Learn",
    });
  }

  Widget _buildStartButton() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 30.0,
        left: MediaQuery.of(context).size.width * UiUtils.hzMarginPct,
        right: MediaQuery.of(context).size.width * UiUtils.hzMarginPct,
      ),
      child: CustomRoundedButton(
        widthPercentage: MediaQuery.of(context).size.width,
        backgroundColor: Theme.of(context).primaryColor,
        buttonTitle:
            AppLocalization.of(context)!.getTranslatedValues(letsStart)!,
        radius: 8,
        onTap: navigateToQuestionScreen,
        titleColor: Theme.of(context).colorScheme.background,
        showBorder: false,
        height: 58.0,
        elevation: 5.0,
        textSize: 18,
        fontWeight: FontWeights.semiBold,
      ),
    );
  }

  Widget _buildParagraph() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.height * .75,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * UiUtils.hzMarginPct,
      ),
      child: SingleChildScrollView(
        // padding: const EdgeInsets.only(bottom: 100),
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
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _buildParagraph(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildStartButton(),
          ),
        ],
      ),
    );
  }
}
class FunAndLearnScreen extends StatefulWidget {
  @override
  _FunAndLearnScreenState createState() => _FunAndLearnScreenState();
}

class _FunAndLearnScreenState extends State<FunAndLearnScreen> {
  IosInsecureScreenDetector? _iosInsecureScreenDetector;
  late bool isScreenRecordingInIos = false;

  @override
  void initState() {
    super.initState();
    _secureScreen();
  }

  Future<void> _secureScreen() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } else if (Platform.isIOS) {
      _iosInsecureScreenDetector = IosInsecureScreenDetector();
      await _iosInsecureScreenDetector?.initialize();
      _iosInsecureScreenDetector?.addListener(
        iosScreenshotCallback,
        iosScreenRecordCallback,
      );
    }
  }

  void iosScreenshotCallback() {
    // Handle screenshot detection
    print("Screenshot taken");
  }

  void iosScreenRecordCallback(bool isRecording) {
    setState(() {
      isScreenRecordingInIos = isRecording;
    });
    // Handle screen recording detection
    print("Screen recording: $isRecording");
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } else if (Platform.isIOS) {
      _iosInsecureScreenDetector?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fun and Learn Screen'),
      ),
      body: Center(
        child: Text('This is the fun and learn screen'),
      ),
    );
  }
}
