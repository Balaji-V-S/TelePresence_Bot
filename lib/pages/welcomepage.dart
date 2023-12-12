import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'homepage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(1, 13, 13, 13),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 125),
              child: LottieBuilder.asset(
                'assets/animations/droid.json',
                width: 350,
              ),
            ),
            const SizedBox(height: 50),
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.65),
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 0.56),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child: const Text(
                'Welcome To',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Image.asset('assets/Images/saiinc.png', scale: 2.5),
            const SizedBox(height: 120),
            Container(
              decoration: BoxDecoration(
                  border: const GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(13, 9, 255, 100),
                        Color.fromRGBO(229, 74, 74, 65),
                        Color.fromRGBO(246, 246, 246, 100)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(60)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const MenuPage(),
                        ),
                      );
                    },
                    child: const Text('Get Started',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
