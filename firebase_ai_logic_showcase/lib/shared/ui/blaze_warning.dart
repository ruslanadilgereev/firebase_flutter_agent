import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../firebase_options.dart';

class BlazeWarning extends StatefulWidget {
  const BlazeWarning({super.key});

  @override
  State<BlazeWarning> createState() => _BlazeWarningState();
}

class _BlazeWarningState extends State<BlazeWarning> {
  final GlobalKey _textKey = GlobalKey();

  void _launchBlazeUrl() {
    final projectId = DefaultFirebaseOptions.currentPlatform.projectId;
    final url = Uri.parse(
      'https://console.firebase.google.com/project/$projectId/overview?purchaseBillingPlan=metered',
    );
    launchUrl(url, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: RichText(
          key: _textKey,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            text: 'This demo requires Blaze plan, which you can ',
            children: [
              TextSpan(
                text: 'enable in the Firebase Console.',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()..onTap = _launchBlazeUrl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
