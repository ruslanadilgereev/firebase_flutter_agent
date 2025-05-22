import 'package:acrings_native/activity_rings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey,
        brightness: Brightness.dark),
      ),
      home: const MyHomePage(title: 'Activity Stats'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 200, width: 0,
            child:
            ActivityRings()),
            Text("Move", style: textTheme.displaySmall?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),),
            Text("Exercise",style: textTheme.displaySmall?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),),
            Text("Stand",style: textTheme.displaySmall?.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
