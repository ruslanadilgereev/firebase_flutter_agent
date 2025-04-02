import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../greenthumb/service.dart';
import '../styles.dart';
import 'view_model.dart';

class UserPromptPicker extends StatelessWidget {
  UserPromptPicker({this.onRequest, required Message message, super.key})
    : assert(message is UserRequest),
      selectedAction = GardeningAction.fromPrompt(message.text);

  final GardeningAction? selectedAction;
  final ToolRequestCallback? onRequest;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Spacer(flex: 1),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppLayout.largePadding),
        child: Text(
          'What would you like to do?',
          style: AppTextStyles.subheading,
        ),
      ),
      SizedBox(height: AppLayout.defaultPadding),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppLayout.largePadding),
        child: Center(
          child: Wrap(
            spacing: AppLayout.extraLargePadding,
            runSpacing: AppLayout.defaultPadding,
            alignment: WrapAlignment.center,
            children: [
              for (final action in GardeningAction.values)
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap:
                          onRequest != null
                              ? () => onRequest!(action.prompt)
                              : null,
                      borderRadius: BorderRadius.circular(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            action.icon,
                            size: 28,
                            color: AppColors.primaryDark,
                          ),
                          SizedBox(height: AppLayout.defaultPadding),
                          Text(
                            action.buttonName,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.actionButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      const Spacer(flex: 2),
    ],
  );
}

enum GardeningAction {
  expandGarden(
    buttonName: 'Expand my\ngarden',
    icon: Icons.local_florist_outlined,
    prompt: 'I\'d like to expand my garden.',
  ),
  keepGardenHealthy(
    buttonName: 'Keep my\ngarden healthy',
    icon: Icons.water_drop_outlined,
    prompt: 'I\'d like to keep my garden healthy.',
  );

  const GardeningAction({
    required this.buttonName,
    required this.prompt,
    required this.icon,
  });

  final String buttonName;
  final String prompt;
  final IconData icon;

  static GardeningAction? fromPrompt(String? prompt) =>
      values.firstWhereOrNull((v) => v.prompt == prompt);
}
