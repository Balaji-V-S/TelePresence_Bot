import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import './createQuery.dart';
import './AdsPage.dart';

// ignore: camel_case_types
class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(1, 13, 13, 13),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 50),
              child: Container(
                alignment: Alignment.centerLeft,
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [
                        Color.fromRGBO(255, 255, 255, 0.656),
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromRGBO(255, 255, 255, 0.437),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'Choose an Option              ',
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AdBuilder()));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 43, 43, 43),
                  ),
                  child: Row(
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
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.asset(
                            'assets/cardImg/ads.png',
                            height: 75,
                            width: 75,
                          ),
                        ),
                      ),
                      const Column(
                        children: [
                          Text(
                            'Create Your Advertisement                         ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          Text(
                            ' Create your personalized advertisement and showcase \n using our robot',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 55, right: 5),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SurveyForm()));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 43, 43, 43),
                  ),
                  child: Row(
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
                            'assets/cardImg/survey.png',
                            height: 75,
                            width: 75,
                          ),
                        ),
                      ),
                      const Column(
                        children: [
                          Text(
                            'Create Your Survey                             ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          Text(
                            ' Create a survey with personalized questions and\n get feedback from the audience',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 100, right: 10),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
