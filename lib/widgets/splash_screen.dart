import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/screens/portfolio_screen.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  // ignore: use_super_parameters
  const SplashScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (context) => Portfolio(
                  toggleTheme: widget.toggleTheme,
                )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColor(
        context,
        lightColor: Colors.white,
        darkColor: Colors.black,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedTextKit(
                  key: ValueKey(Theme.of(context).brightness),
                  animatedTexts: [
                    TyperAnimatedText(
                      "Portfolio",
                      textStyle: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: getColor(
                          context,
                          lightColor: Colors.black,
                          darkColor: Colors.white,
                        ),
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  isRepeatingAnimation: false,
                ),
                const SizedBox(height: 30),
                const SpinKitRipple(color: Colors.blueAccent, size: 50.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
