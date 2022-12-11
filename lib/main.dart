import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dll.dart';
import 'player/init.dart';
import 'ui/pages/home.dart';
import '/services/fm.dart';
import 'package:windows_single_instance/windows_single_instance.dart';
Future<void> main(List<String> args)  async {
  WidgetsFlutterBinding.ensureInitialized();
   await WindowsSingleInstance.ensureSingleInstance(
        args,
        "smaq",
        onSecondWindow: (args) {
        });
  Dll.initDLL();
  Bass.init();
  runApp(
      ProviderScope(child: MyApp(args:args)),
    );
    
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.args}) : super(key: key);
final List<String> args;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
 FM.openFiles(widget.args);

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const MPappBar(),
      body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const[],
        ),
     
      bottomNavigationBar: const MPSlider(),
    );
  }
}*/
////////////////