import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  splashScreen(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        return Navigator.of(context).pushReplacementNamed("/Home_Screen");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    splashScreen(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 1,
            colors: [
              Colors.black87,
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            "assets/svg/logo.svg",
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.1,
          ),
        ),
      ),
    );
  }
}
