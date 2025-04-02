import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../styles.dart';
import 'view_model.dart';

class ModelResponseView extends StatelessWidget {
  const ModelResponseView({required this.message, super.key});

  final ModelResponse message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppLayout.extraLargePadding),
    child: SingleChildScrollView(
      child: Center(
        child: MarkdownBody(
          data: message.text,
          styleSheet: MarkdownStyleSheet(
            p: AppTextStyles.body.copyWith(fontWeight: FontWeight.normal),
          ),
          imageBuilder: (uri, title, alt) {
            final image = uri.toString();
            return Image.asset(
              'assets/product-images/$image',
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading image: $error');
                return SizedBox.shrink();
              },
            );
          },
        ),
      ),
    ),
  );
}
