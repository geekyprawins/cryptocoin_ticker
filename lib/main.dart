import 'package:flutter/material.dart';
import 'price_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            primaryColor: Colors.lightBlue,
            scaffoldBackgroundColor: Colors.white),
        home: AnimatedSplashScreen(
          nextScreen: PriceScreen(),
          splash: Image.asset('images/image.png'),
          splashIconSize: 100.0,
          splashTransition: SplashTransition.rotationTransition,
        ));
  }
}
