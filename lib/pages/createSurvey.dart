import 'package:flutter/material.dart';

class SurveyForm extends StatefulWidget {
  const SurveyForm({super.key});

  @override
  State<SurveyForm> createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  int currentStep = 0;
  // ignore: unused_field
  String _value = '';
  void _onchanged(String value) {
    setState(() {
      _value = value;
    });
  }

  void _onsubmit(String value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(1, 13, 13, 13),
      body: Center(
        child: Theme(
          data: ThemeData(),
          child: Stepper(
            currentStep: currentStep,
            onStepTapped: (index) {
              setState(() => currentStep = index);
            },
            onStepContinue: () {
              if (currentStep != 3) {
                setState(() => currentStep++);
              }
            },
            onStepCancel: () {
              if (currentStep != 0) {
                setState(() => currentStep--);
              }
            },
            steps: [
              Step(
                isActive: currentStep >= 0,
                title: const Text(
                  'Name your survey',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                content: Column(
                  children: [
                    const Text(
                      ' SURVEY NAME',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'give your survey a name to tell it apart from other survet',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        onChanged: _onchanged,
                        onSubmitted: _onsubmit,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide:
                                    const BorderSide(color: Colors.white))),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        autocorrect: true,
                      ),
                    ),
                  ],
                ),
              ),
              Step(
                isActive: currentStep >= 1,
                title: const Text(
                  'choose your audience',
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  'welcome',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Step(
                isActive: currentStep >= 2,
                title: const Text(
                  'choose your question',
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  'hii',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Step(
                isActive: currentStep >= 3,
                title: const Text(
                  'publish',
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  'done!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
