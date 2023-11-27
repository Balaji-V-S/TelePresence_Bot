import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../Services/Navdrawer.dart';
import '../Services/SpeechtoText.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/Images/appBar.png',
                  fit: BoxFit.contain,
                  height: 35,
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(right: 90, left: 10),
                  child: Text('TeleMate',
                      style: GoogleFonts.jost(
                          fontSize: 20, fontWeight: FontWeight.bold)))
            ],
          ),
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 254, 252, 252),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        drawer: const NavDrawer(),
        body: Center(
            child: Column(
          children: [
            Container(
              child: Lottie.asset('assets/animations/droid.json', height: 250),
            ),
            // const SizedBox(height: 100),
            Text(
              'Whom do you want to visit?',
              style: GoogleFonts.comfortaa(fontSize: 20),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(222, 255, 255, 255),
                          Color.fromARGB(239, 181, 190, 243)
                        ]),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          Image.asset(
                            'assets/Images/officials.png',
                            width: 150,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              "Officials",
                              style: GoogleFonts.comfortaa(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => const QueryModel()));
                    },
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(222, 255, 255, 255),
                          Color.fromARGB(239, 181, 190, 243)
                        ]),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          Image.asset(
                            'assets/Images/engineer.png',
                            width: 150,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              "Projects",
                              style: GoogleFonts.comfortaa(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) =>const QueryModel()));
                    },
                  ),
                ],
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
