import 'dart:ffi';
import 'dart:io';
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
            LottieShadow(
              shadowColor: Color.fromRGBO(123, 97, 255, 0.5),
              child: Lottie.asset('assets/animations/droid.json', height: 600),
            ),
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.07),
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 0),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child: const Text(
                '                  Choose a Category               ',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 432,
                        width: 669,
                        color: const Color.fromRGBO(43, 43, 43, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              width: 100,
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
                              child: Image.asset('assets/cardImg/botIcon.png'),
                            ),
                            Container(
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
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: const Text(
                                'Explore our newest chatbot and discover its innovative features!',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Roboto'),
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
                    const SizedBox(width: 20),
                    GestureDetector(
                      child: Container(
                        height: 432,
                        width: 669,
                        color: const Color.fromRGBO(43, 43, 43, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              width: 100,
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
                              child: Image.asset('assets/cardImg/adList.png'),
                            ),
                            Container(
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
                            Container(
                              child: const Text(
                                'Explore our features to create Ads and showcase them!',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const optionsPage()));
                      },
                    ),
                  ],
                ),
              ),
            )
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
            title: const Text("Really?"),
            content: const Text("Do you want to exit the App?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  //Navigator.of(context).pop(true);
                  exit(0);
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No"),
              )
            ],
          );
        });
    return exitApp ?? false;
  }
}
