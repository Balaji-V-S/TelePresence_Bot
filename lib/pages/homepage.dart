import 'dart:ffi';
import 'dart:io';
import 'package:lmes/Services/alan_ai.dart';
import 'AdsPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:lottie/lottie.dart';
import './optionsPage.dart';
import '../Services/Navdrawer.dart';
import '../Services/SpeechtoText.dart';
import '../components/shadowLottie.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(1, 13, 13, 13),
        body: Center(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: LottieShadow(
                shadowColor: Color.fromRGBO(123, 97, 255, 0.5),
                child:
                    Lottie.asset('assets/animations/droid.json', height: 350),
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.573),
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 0.466),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child: const Text(
                'Choose a Category',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 70),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Expanded(
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 43, 43, 43),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(25),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  width: 75,
                                  height: 75,
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
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Image.asset(
                                    'assets/cardImg/botIcon.png',
                                    height: 75,
                                    width: 75,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, bottom: 10),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Sairam-X',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 30, left: 25, right: 25),
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: const Text(
                                    'Explore our newest chatbot and discover\nits innovative features!',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'Roboto'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const QueryModel()));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Expanded(
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 43, 43, 43),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(25),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  height: 75,
                                  width: 75,
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
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Image.asset(
                                    'assets/cardImg/adList.png',
                                    height: 75,
                                    width: 75,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, bottom: 10),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Build Your Ad',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, bottom: 30, right: 50),
                                child: Container(
                                  child: const Text(
                                    'Explore our features to create Ads\nand showcase them!',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'Roboto'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const OptionsPage()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
      onWillPop: () => _onBackpressed(context),
    );
  }

  Future<bool> _onBackpressed(BuildContext context) async {
    bool? exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(150, 13, 13, 13),
            title: const Text("Really?",style: TextStyle(color: Colors.white),),
            content: const Text("Do you want to exit the App?",style: TextStyle(color: Colors.white)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  //Navigator.of(context).pop(true);
                  exit(0);
                },
                child: const Text("Yes",style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No",style: TextStyle(color: Colors.white)),
              )
            ],
          );
        });
    return exitApp ?? false;
  }
}
