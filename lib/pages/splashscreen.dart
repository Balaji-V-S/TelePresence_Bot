import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import './welcomepage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color.fromARGB(1, 13, 13, 13),
      splashIconSize: MediaQuery.of(context).size.height,
      splash: Container(
        color: const Color.fromARGB(1, 13, 13, 13),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              SizedBox(
                child: Lottie.asset(
                  'assets/animations/droid.json',
                ),
                width: 350,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/Images/incLogo.png',width:100),
                  SizedBox(height: 20,),
                  const Text(
                    "Sri Sairam",
                    style: TextStyle(fontSize: 10, color: Colors.white,fontStyle: FontStyle.italic),
                  ),
                  const Text(
                    "TECHNO INCUBATION",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  const Text(
                    "FOUNDATION",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
      nextScreen: const WelcomePage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
    );
  }
}
