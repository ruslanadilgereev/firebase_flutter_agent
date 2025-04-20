import 'package:flutter/material.dart';
import '../../settings/styles.dart';

class GoHomeButton extends StatelessWidget {
  const GoHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Size.m),
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          onPressed:
              () => Navigator.of(context).popUntil((route) => route.isFirst),
          icon: Icon(Icons.home),
          label: Text(
            style: TextStyle(fontSize: 24),
            'Great! Go back to main menu.',
          ),
        ),
      ),
    );
  }
}
