import 'package:blindtestlol_flutter_app/component/loadingPage.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Ensure this path is correct
// Ensure this path is correct

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppText.title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        fontFamily: 'CustomFont1',
        scaffoldBackgroundColor: AppColors.colorNoirHextech,
      ),
      home: const LoadingPage(),
    );
  }
}
