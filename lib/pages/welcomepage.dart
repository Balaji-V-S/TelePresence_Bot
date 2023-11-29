import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:bouncing_button/bouncing_button.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120),
              child: LottieBuilder.asset(
                'assets/animations/droid.json',
                width: 350,
              ),
            ),
            const SizedBox(height: 50
            ),
            Text('Welcome To',style:GoogleFonts.jost(fontSize: 25),),
            // const SizedBox(height: 0),
            Image.asset('assets/Images/incubationlogo.png', scale: 2.6),
            const SizedBox(height: 60),
            BouncingButton(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromARGB(220, 67, 137, 251),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      "Get Started!",
                      style: GoogleFonts.jost(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ),
                  
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => MenuPage()));
                }),
          ],
        ),
      ),
    );
  }
}
