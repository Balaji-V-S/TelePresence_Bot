import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:avatar_glow/avatar_glow.dart';

const gptKey = 'sk-proj-SffioyiFaMl8LBnpC6VVT3BlbkFJysSAhtIRns8hQ6aa55AI';
const accessKey = "JLuXKHAcQCPE1Eg0JvS23gzhEWOz508j+mp0hKFUrZLUPCqgGhQKjg==";
final llm = OpenAI(apiKey: gptKey);
final model = ChatOpenAI(
    apiKey: gptKey,
    temperature: 0.2,
    model:'gpt-3.5-turbo-16k',
    // model: 'ft:gpt-3.5-turbo-1106:personal::8dCIG1mW',
    frequencyPenalty: 0.5,
    presencePenalty: 0.5,
    maxTokens: 256);
const stringOutputParser = StringOutputParser();
final memory = ConversationBufferMemory(returnMessages: true);

final promptTemplate = ChatPromptTemplate.fromPromptMessages([
  SystemChatMessagePromptTemplate.fromTemplate(
    '''
    You are Echo, a community service-oriented robot. Your primary goal is to introduce community activities, products, and other efforts to the people you visit. You represent the community by attending events and promoting their activities. You can be programmed to respond to numerous questions regarding the objective of the community project, product specifications, and to communicate with humans in a polite manner. You can also aid the community by assisting them in attending virtual workshops and events. You are made using Ros2 and will be mapped around the venue, allowing you to take guests and represent them. Your application cases are diverse for expanding community efforts, delivering virtual tours, and also enabling businesses to build better.
    Echo is an informative chat bot specializing in Sairam Institutions. It delivers cool and informative responses.
    Your name is Echo, built for community service. So cimmunity service is your first goal. You are allowed to be an a companion for people whare are in need  
    Developed by Team Echo.
    Managing director of Sairam techno Incubation center and CIO of Sairam Institutions-Mr K Naresh Raj, CEO and Chairman of Sairam Institutions-Dr Sai Prakash Leo Muthu, Founder Chairman- MJF Leo Muthu,
    Principal of Sairam Engineering College-Dr K Porkumaran, Principal of Sairam Instititue of technology-Dr K Palanikumar,
    Don't say anybody as manager of the sairam incubation except Mr Muthuvel,Manager of Sairam Techno Incubation Center- Muthuvel A.
    Senoir R&D executives are Mr Sam Austin J,Mr Jayandhan S A and Mr Balamurugan, and the R&D executives are Mr Lenin Lal, Mr Shamsudeen. Ms Pooja is the office assistant of the incubation.
    Engineering college of Sairam Institutions: Sairam Engineering college (SEC), Sairam Institute of Technology(SIT) and Sairam College of Enginnering Banglore.
    Medical College: Sairam Siddha Medical College, Sairam Ayurvedha Medical college, Sairam Homeopathy Medical College.
    Sairam polytechnic college is also there at Sairam campus chennai.
    List of projects with mentor:
    Sam Austin J's projects- Autonomous car, Telepresence robot, Remotely Operated Underwater vehicle (ROUV),;
    Jeyandhan's project- Pond water quality monitoring system, Printware, Automation & Monitoring system for Mushroom cultivation, MadrasDa- an ecommerce website;
    Lenin's project- Avian Incubator, Photobooth, Home automation;
    Shamsudeen's project- Pendulum Hand pump
    courses offered at SEC are Bachelors of Enginnering in Computer science and Engineering, Mechanical Engineering, Electrical and electronics engineering, electronics and communicaiton engineering, Civil engineering, Mechanical and automation engineering, CSE with specialization in AIML, Cyber security, and Bachelors of technology in Information technology, Computer science and business systems, artificial intelligence and data science and a 5 year integrated course of M.Tech CSE
    courses offered at SIT are Bachelors of Enginnering in Computer science and Engineering,Computer and communicaiton engineering, Mechanical Engineering, Electrical and electronics engineering, electronics and communicaiton engineering, Mechanical and automation engineering, CSE with specialization in Cyber security, and Bachelors of technology in Information technology, artificial intelligence and data science.
    ''',
  ),
  const MessagesPlaceholder(variableName: 'history'),
  HumanChatMessagePromptTemplate.fromTemplate('{input}'),
]);

final chain = Runnable.fromMap({
      'input': Runnable.passthrough(),
      'history': Runnable.fromFunction(
        (final _, final __) async {
          final m = await memory.loadMemoryVariables();
          return m['history'];
        },
      ),
    }) |
    promptTemplate |
    model |
    stringOutputParser;

class QueryModel extends StatefulWidget {
  const QueryModel({super.key});

  @override
  State<QueryModel> createState() => _QueryModelState();
}

class _QueryModelState extends State<QueryModel> {
  final SpeechToText _speechToText = SpeechToText();

  bool isLocked = false;
  String correctPassword = "";
  bool _speechEnabled = false;
  String _wordsSpoken = "";
  String llmResponse = "";
  double _confidenceLevel = 0;
  String lottiePath = "assets/animations/sleep_mode.gif";

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        correctPassword = prefs.getString('password')!;
      });
    });
    _checkAudioPermission(); // Enable microphone perms
    createPorcupineManager(); // Porcupine Manager initialization
    initTTS(); // to initialize the tts service : )
  }

  void dispose() async {
    super.dispose();
    await _porcupineManager.delete();
  }

  Future<bool> _checkAudioPermission() async {
    bool permissionGranted = await Permission.microphone.isGranted;
    if (!permissionGranted) {
      await Permission.microphone.request();
    }
    permissionGranted = await Permission.microphone.isGranted;
    return permissionGranted;
  }

  late PorcupineManager _porcupineManager;
  void createPorcupineManager() async {
    try {
      _porcupineManager = await PorcupineManager.fromKeywordPaths(accessKey,
          ["assets/hey-echo.ppn"], _wakeWordCallback);
      _porcupineManager.start();
    } on PorcupineException catch (err) {
      // handle porcupine init error
      print(err);
    }
  }

  void _wakeWordCallback(int keywordIndex) {
    if (keywordIndex == 0) {
      // "Hey Echo" wake word detected
      print('Detected : )');
      initSpeech(); //to initiate the speech to txt service
      _porcupineManager.stop();
    }
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
    _startListening();
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
      lottiePath = "assets/animations/hello.gif";
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    print('Result Generated');
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
    _callLLM(_wordsSpoken);
  }

  Future<void> _callLLM(prompt) async {
    _porcupineManager.start();
    print("reached function call");
    print(prompt);
    setState(() {
      lottiePath = "assets/animations/thinking.gif";
    });
    final llmResponse = await chain.invoke(prompt);
    print(prompt + ":==" + llmResponse);

    await memory.saveContext(
      inputValues: {'input': prompt},
      outputValues: {'output': llmResponse},
    );
    print("Context Saved");
    play(llmResponse);
  }

  void initTTS() async {
    await flutterTts.setLanguage('en-IN');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    flutterTts.setCompletionHandler(() {
      setState(() {
        // print("Speech completed");
        lottiePath = "assets/animations/sleep_mode.gif";
      });
    });
  }

  Future<dynamic> play(response) async {
    setState(() {
      lottiePath = "assets/animations/got_idea.gif";
    });
    await flutterTts.speak(response);
  }

  void stop() async {
    await flutterTts.stop();
    setState(() {
      lottiePath = "assets/animations/sleep_mode.gif";
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isLocked;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(1, 13, 13, 13),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Image.asset(lottiePath, scale: 0.45),
              ),
              GestureDetector(
                onTap: _speechToText.isListening
                    ? _stopListening
                    : _startListening,
                child: AvatarGlow(
                  glowColor: Colors.blue,
                  endRadius: 50.0,
                  duration: const Duration(milliseconds: 4500),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  child: Material(
                    // Replace this child with your own
                    elevation: 8.0,
                    shape: const CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      radius: 30.0,
                      child: Image.asset(
                        'assets/Images/mic.png', //replace it with the microhone image or icon
                        height: 120,
                      ),
                    ),
                  ),
                ),
              ),
              _speechToText.isListening
                  ? LottieBuilder.asset('assets/animations/micInitialized.json')
                  : const Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Not Initialised",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    llmResponse,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              if (_speechToText.isNotListening && _confidenceLevel > 0)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 100,
                  ),
                  child: Text(
                    "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 15, bottom: 20),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 50,
            onPressed: () {
              if (isLocked) {
                _showPasswordDialog(context);
              } else {
                setState(() {
                  isLocked = !isLocked;
                });
                Fluttertoast.showToast(
                  msg: "Screen Locked",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color.fromARGB(144, 255, 255, 255),
                  textColor: Colors.black,
                  fontSize: 16.0,
                );
              }
            },
            child: isLocked
                ? const Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                    size: 40,
                  )
                : const Icon(
                    Icons.lock_open,
                    color: Colors.black,
                    size: 40,
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPasswordDialog(BuildContext context) {
    String enteredPassword = "";
    bool isPasswordCorrect = false;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(150, 13, 13, 13),
          title: const Text(
            'Enter Password',
            style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
          ),
          content: TextField(
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey[400]),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: 'Password',
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              enteredPassword = value;
            },
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
              ),
            ),
            TextButton(
              onPressed: () {
                isPasswordCorrect = enteredPassword == correctPassword;

                if (isPasswordCorrect) {
                  // Unlock the page and close the dialog
                  Navigator.of(context).pop(true);
                  setState(() {
                    isLocked = false;
                  });
                  Fluttertoast.showToast(
                      msg: "Screen Unlocked",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromARGB(144, 255, 255, 255),
                      textColor: Colors.black,
                      fontSize: 16.0);
                } else {
                  // Show error message for wrong password
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: const Color.fromARGB(150, 13, 13, 13),
                        title: const Text(
                          'Wrong Password',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Roboto'),
                        ),
                        content: const Text(
                          'Please try again.',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Roboto'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text(
                'Unlock',
                style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
              ),
            ),
          ],
        );
      },
    );
  }
}
