import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import './AdsPage.dart';

class optionsPage extends StatelessWidget {
  const optionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(1, 13, 13, 13),
      body: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 255, 255, 0.5),
                      Color.fromRGBO(255, 255, 255, 1),
                      Color.fromRGBO(255, 255, 255, 0),
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
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AdBuilder()));
              },
              child: Container(
                color: const Color.fromRGBO(43, 43, 43, 100),
                child: Row(
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
                      child: Image.asset('assets/cardImg/ads.png'),
                    ),
                    const Column(
                      children: [
                        Text(
                          'Create Your Advertisement',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: 20),
                        ),
                        Text(
                          ' Create your personalized advertisement and showcase \n using our robot.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Container(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AdBuilder()));
              },
              child: Container(
                color: const Color.fromRGBO(43, 43, 43, 100),
                child: Row(
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
                      child: Image.asset('assets/cardImg/survey.png'),
                    ),
                    const Column(
                      children: [
                        Text(
                          'Create Your Survey',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: 20),
                        ),
                        Text(
                          ' Create a survey with personalized questions and get feedback\n from the audience. ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
      ),
    );
  }
}
