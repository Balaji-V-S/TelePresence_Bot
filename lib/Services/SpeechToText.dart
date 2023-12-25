import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:avatar_glow/avatar_glow.dart';

const gptKey = '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';
final llm = OpenAI(apiKey: gptKey);
final model =
    ChatOpenAI(apiKey: gptKey, temperature: 0.5, model: 'gpt-3.5-turbo-1106',maxTokens: 128);
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
  String lottiePath = "assets/animations/droid.json";

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
    initSpeech();
    initTTS();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
    _callLLM(_wordsSpoken);
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
  }

  Future<void> _callLLM(prompt) async {
    prompt ='GPT 3.6 turbo 1106 vs davinci for conversational data?';
    print("reached function call");
    setState(() {
      lottiePath = "assets/animations/loading.json";
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
        lottiePath = "assets/animations/droid.json";
      });
    });
  }

  Future<dynamic> play(response) async {
    setState(() {
      lottiePath = "assets/animations/speaking.json";
    });
    await flutterTts.speak(response);
  }

  void stop() async {
    await flutterTts.stop();
    setState(() {
      lottiePath = "assets/animations/droid.json";
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
                padding: const EdgeInsets.all(30),
                child: Lottie.asset(lottiePath, height: 375),
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
        floatingActionButton: FloatingActionButton.large(
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
