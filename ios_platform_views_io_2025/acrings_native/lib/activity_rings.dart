import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ActivityRings extends StatefulWidget {
  const ActivityRings({super.key});

  @override
  _ActivityRingsState createState() => _ActivityRingsState();
}

class _ActivityRingsState extends State<ActivityRings> {
  @override
  Widget build(BuildContext context) {
    const String viewType = 'activity_rings';
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    switch(defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      case TargetPlatform.macOS:
        return AppKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        throw UnsupportedError("Unsupported platform view");
    }
  }
}
