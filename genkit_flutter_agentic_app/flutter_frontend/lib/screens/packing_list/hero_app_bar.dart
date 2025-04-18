import 'package:flutter/material.dart';
import '../../settings/styles.dart';

class HeroAppBar extends StatelessWidget {
  const HeroAppBar({required this.title, required this.imageUrl, super.key});

  final Widget title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actionsPadding: EdgeInsets.zero,
      pinned: true,
      expandedHeight: heroAppBarHeight,
      backgroundColor: Theme.of(context).colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        title: title,
        background: Stack(
          children: [
            SizedBox(
              height: 350,
              width: double.infinity,
              child: Image.network(
                loadingBuilder: (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                    ),
                  );
                },
                errorBuilder: (
                  BuildContext context,
                  Object exception,
                  StackTrace? stackTrace,
                ) {
                  return Center(child: Text('Failed to load image'));
                },
                fit: BoxFit.cover,
                imageUrl,
              ),
            ),
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface.withAlpha(0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
