import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ai/firebase_ai.dart';
import '../app_state.dart';
import '../utils/utils.dart';
import './tools.dart';

class AppAgent {
  final gemini = FirebaseAI.vertexAI().generativeModel(
    systemInstruction: Content.text('''
      You are a friendly and helpful app concierge. Your job is to help the user
      get the best, frictionless app experience. 
      If you have access to a tool that can configure the setting for
      the user and address their feedback, ALWAYS ask the user to confirm the
      change before making the change.
      Before filing a feedback report, first gather all of the following information:
      - Device Information
      - When the user has feedback regarding performance, also include battery information.
      to include in the feedback report.
      '''),
    model: 'gemini-2.0-flash',
    toolConfig: ToolConfig(
      functionCallingConfig: FunctionCallingConfig.any({
        'askConfirmation',
        'setFontFamily',
        'setFontSizeFactor',
        'setAppColor',
        'getDeviceInfo',
        'getBatteryInfo',
        'fileFeedback',
      }),
    ),
    tools: [
      Tool.functionDeclarations([
        askConfirmationTool,
        fontFamilyTool,
        fontSizeFactorTool,
        appThemeColorTool,
        deviceInfoTool,
        batteryInfoTool,
        fileFeedbackTool,
      ]),
    ],
  );
  late ChatSession chat;
  late Uint8List screenshot;
  late String feedbackText;

  initialize() {
    chat = gemini.startChat();
  }

  Future<bool> askConfirmation(BuildContext context, String question) async {
    var response = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Theme(
          data: context.read<AppState>().appTheme,
          child: AlertDialog(
            title: Text('App Manager'),
            content: Text(question),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Yes, please'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No.'),
              ),
            ],
          ),
        );
      },
    );

    return response ?? false;
  }

  Future<GenerateContentResponse?> askConfirmationCall(
    BuildContext context,
    FunctionCall functionCall,
  ) async {
    var question = functionCall.args['question']! as String;

    if (context.mounted) {
      final functionResult = await askConfirmation(context, question);

      final response = await chat.sendMessage(
        functionResult
            ? Content.text('Yes, please do that.')
            : Content.text('No, thank you.'),
      );

      return response;
    }
    return null;
  }

  void checkFunctionCalls(
    BuildContext context,
    Iterable<FunctionCall> functionCalls,
  ) async {
    for (var functionCall in functionCalls) {
      debugPrint(functionCalls.map((fc) => fc.name).toString());
      GenerateContentResponse? response;
      switch (functionCall.name) {
        case 'askConfirmation':
          response = await askConfirmationCall(context, functionCall);
        case 'setFontFamily':
          setFontFamilyCall(context, functionCall);
        case 'setFontSizeFactor':
          setFontSizeFactorCall(context, functionCall);
        case 'setAppColor':
          setAppColorCall(context, functionCall);
        case 'getDeviceInfo':
          var deviceInfo = await getDeviceInfoCall();
          response = await chat.sendMessage(
            Content.text('Device Info: $deviceInfo'),
          );
        case 'getBatteryInfo':
          var batteryInfo = await getBatteryInfoCall();
          response = await chat.sendMessage(
            Content.text('Battery Info: $batteryInfo'),
          );
        case 'fileFeedback':
          var feedbackReport = await fileFeedbackReport(context, functionCall);
          await chat.sendMessage(
            Content.text(
              'Feedback Report successfully filed: $feedbackReport.',
            ),
          );
          return;
        default:
          throw UnimplementedError(
            'Function not declared to the model: ${functionCall.name}',
          );
      }
      if (response != null &&
          response.functionCalls.isNotEmpty &&
          context.mounted) {
        checkFunctionCalls(context, response.functionCalls);
      }
    }
    return;
  }

  Future<String> fileFeedbackReport(
    BuildContext context,
    FunctionCall functionCall,
  ) async {
    String summary = functionCall.args['summary'] as String;
    String deviceInfo = functionCall.args['deviceInfo'] as String;
    String batteryInfo = functionCall.args['batteryInfo'] as String? ?? '';
    String actionHistory = functionCall.args['actionHistory'] as String;
    List<dynamic> tagsList = functionCall.args['tags'] as List<dynamic>;
    List<String> tags = tagsList.map((tag) => tag as String).toList();
    int priority = functionCall.args['priority'] as int;

    String feedbackReport = '''
    Summary: $summary\n
    Device Info: $deviceInfo\n
    Battery Info: $batteryInfo\n
    Action History: $actionHistory\n
    Tags: $tags\n
    Priority: $priority\n
    Feedback: $feedbackText\n
    ''';

    AppState manager = context.read<AppState>();

    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: manager.appTheme,
          child: AlertDialog(
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
            ],
            title: Text('Feedback Report'),
            content: Column(
              children: [
                Text('Summary:$summary'),
                Text('Device Info: $deviceInfo'),
                Text('Battery Info: $batteryInfo'),
                Text('Action History: $actionHistory'),
                Text('Tags: ${tags.join(' ')}'),
                Text('Priority: $priority'),
                Text('Feedback: $feedbackText'),
                Image.memory(screenshot),
              ],
            ),
            scrollable: true,
          ),
        );
      },
    );

    return feedbackReport;
  }

  void submitFeedback(
    BuildContext context,
    Uint8List userScreenshot,
    String userFeedbackText,
  ) async {
    screenshot = userScreenshot;
    feedbackText = userFeedbackText;

    final prompt = Content.multi([
      TextPart(
        '''Please recommend ways for the user to address their own feedback.
           ALWAYS respond using the ask Confirmation Tool to show an alert dialog and ask the user for their confirmation before making a change.
           If the user denies a change that you've recommend, proceed to file a feedback report for them.
        ''',
      ),
      TextPart('This is the user feedback: $feedbackText'),
      InlineDataPart('image/jpeg', screenshot),
    ]);

    final response = await chat.sendMessage(prompt);

    final functionCalls = response.functionCalls.toList();

    if (context.mounted && functionCalls.isNotEmpty) {
      checkFunctionCalls(context, functionCalls);
    }
  }
}
