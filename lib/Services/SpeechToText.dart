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

const gptKey = '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';
const accessKey = "L2o8eihvj5utq7o0fX2kA4MInDKyADFDT3obnGKklocwvCJ1Y+9OoQ==";
final llm = OpenAI(apiKey: gptKey);
final model = ChatOpenAI(
    apiKey: gptKey,
    temperature: 0.5,
    model: 'ft:gpt-3.5-turbo-1106:personal::8bU5NMQ7',
    maxTokens: 128);
const stringOutputParser = StringOutputParser();
final memory = ConversationBufferMemory(returnMessages: true);

final promptTemplate = ChatPromptTemplate.fromPromptMessages([
  SystemChatMessagePromptTemplate.fromTemplate(
    'SairamX is an informative chat bot specializing in Sairam Institutions. It delivers cool and informative responses',
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
    _checkAudioPermission();
    createPorcupineManager();
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
          ["assets/keyword.ppn", "assets/stop.ppn"], _wakeWordCallback,sensitivities: [1.0,1.0]);

      _porcupineManager.start();
    } on PorcupineException catch (err) {
      // handle porcupine init error
      print(err);
    }
  }

  void _wakeWordCallback(int keywordIndex) {
    if (keywordIndex == 0) {
      // "Hey Buddy" wake word detected
      // Do something
      print('Detected : )');
      initSpeech();
      _porcupineManager.stop();
    } else if (keywordIndex == 1) {
      // "Hey Stop" wake word detected
      // Do something else
      print('Speech Stopped : (');
      flutterTts.stop();
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
    print("reached function call");
    setState(() {
      lottiePath = "assets/animations/thinking.gif";
    });
    final llmResponse = await chain.invoke(prompt);
    print(prompt + ":" + llmResponse);

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
    _porcupineManager.start();
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
                child: Image.asset(lottiePath, scale: 0.4),
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
