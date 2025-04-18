import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/traveler_form_model.dart';
import 'settings/theme.dart';
import 'screens/traveler_form/traveler_form.dart';

void main() {
  runApp(const MyApp());
}

//final packingList = PackingListModel();
final travelerForm = TravelerFormModel();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Packing List',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: Navigator(
        key: _rootNavigatorKey,
        onGenerateRoute:
            (route) => MaterialPageRoute(
              settings: route,
              builder:
                  (context) => ChangeNotifierProvider.value(
                    value: TravelerFormModel(),
                    child: TravelerFormScreen(),
                  ),
            ),
      ),
    );
  }
}
