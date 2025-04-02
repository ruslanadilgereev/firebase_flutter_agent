import 'package:flutter/material.dart';
import 'package:flutter_fix_warehouse/main.dart';

import '../../greenthumb/service.dart';
import '../../styles.dart';
import '../../views/interrupt_choice_picker.dart';
import '../../views/interrupt_image_picker.dart';
import '../../views/interrupt_range_value_picker.dart';
import '../../views/model_response_view.dart';
import '../../views/user_prompt_picker.dart';
import '../../views/view_model.dart';
import '../../widgets/app_navigation_bar.dart';
import '../../widgets/sparkle_leaf.dart';

class WizardPage extends StatefulWidget {
  const WizardPage({super.key});

  @override
  State<WizardPage> createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  final GreenthumbService _service = GreenthumbService();

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _service,
    builder: (context, child) {
      final messages = _service.messages;
      final currentMessage = messages.isEmpty ? null : messages.last;
      final screenWidth = MediaQuery.of(context).size.width;

      return Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: BackButton(color: AppColors.appBackground),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SparkleLeaf(),
              const SizedBox(width: 8),
              Text('GreenThumb', style: AppTextStyles.appBarTitle),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.appBackground),
              onPressed: _service.clear,
            ),
          ],
          centerTitle: true,
        ),
        body: Row(
          children: [
            if (screenWidth >= breakpoint) AppNavigationRail(),
            currentMessage == null || _service.isLoading
                ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
                : Expanded(child: _buildStepView(currentMessage, true)),
          ],
        ),
        bottomNavigationBar:
            screenWidth < breakpoint ? const AppNavigationBar() : null,
      );
    },
  );

  Widget _buildStepView(Message message, bool isCurrentStep) {
    // don't allow the user to form a request if we're already handling one
    final onRequest = isCurrentStep ? _onRequest : null;

    // don't allow the user to create a response if the tool already has one
    final hasToolResponse =
        message is InterruptMessage && message.toolResponse != null;
    final onResume = isCurrentStep && !hasToolResponse ? _onResume : null;

    return switch (message) {
      // gather initial user prompt
      UserRequest() => UserPromptPicker(message: message, onRequest: onRequest),

      // display final model response
      ModelResponse() => ModelResponseView(message: message),

      // Handle interrupt tools
      InterruptMessage() => switch (message.toolRequest!.name) {
        'choice' => InterruptChoicePicker(message: message, onResume: onResume),
        'image' => InterruptImagePicker(message: message, onResume: onResume),
        'range' => InterruptRangeValuePicker(
          message: message,
          onResume: onResume,
        ),
        _ => throw Exception('Unknown tool: ${message.toolRequest!.name}'),
      },
    };
  }

  void _onRequest(String prompt) => _service.request(prompt);

  void _onResume({String? ref, required String name, required String output}) =>
      _service.resume(ref: ref, name: name, output: output);
}
