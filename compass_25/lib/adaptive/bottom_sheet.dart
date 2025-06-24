import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

void showBottomSheetAdaptive({
  required BuildContext context,
  required Widget child,
  NavigatorState? navigatorState,
}) {
  navigatorState ??= Navigator.of(context);

  if (defaultTargetPlatform == TargetPlatform.iOS) {
    navigatorState.push(cupertinoRoute(child));
  } else {
    navigatorState.push(androidRoute(child));
  }
}

PageRoute cupertinoRoute(Widget child) {
  return CupertinoSheetRoute<void>(builder: (context) => child);
}

PageRoute androidRoute(Widget child) {
  return PageRouteBuilder(
    opaque: false,
    pageBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) => child,
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        ),
  );
}
