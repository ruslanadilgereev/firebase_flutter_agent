import 'package:flutter/material.dart';
import '../../settings/styles.dart';

class GetPackingListButton extends StatelessWidget {
  const GetPackingListButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(Spacing.l),
      child: ElevatedButton.icon(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: Spacing.s, horizontal: Spacing.l),
          ),
          textStyle: WidgetStatePropertyAll(
            Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 18),
          ),
          foregroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.onPrimary,
          ),
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        label: Text(style: TextStyle(fontSize: 24), 'Get my packing list'),
        onPressed: onPressed,
        icon: const Icon(Icons.luggage, size: 32),
      ),
    );
  }
}
