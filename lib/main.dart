import 'package:flutter/material.dart';
import 'package:todo_note/screen_widgets/home_screen_widget.dart';
import 'package:todo_note/screen_widgets/splash_screen_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Todo Note",
        theme: ThemeData(
          fontFamily: "Acme",
          useMaterial3: true,
          primarySwatch: Colors.blueGrey,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/Splash_Screen',
        routes: {
          '/Splash_Screen': (context) => const SplashScreenWidget(),
          '/Home_Screen': (context) => const HomeScreenWidget(),
        },
      );
}
