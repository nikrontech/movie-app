import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/pages/schedule_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
    );

    return MaterialApp(
      title: 'Movie app',
      theme: ThemeData(
        primaryColor: Colors.white,
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.black),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          color: Colors.black,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
      ),
      home: const SchedulePage(),
    );
  }
}
