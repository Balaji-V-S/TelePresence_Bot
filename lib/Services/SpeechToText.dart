// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:avatar_glow/avatar_glow.dart';

const gptKey = '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';
final llm = OpenAI(apiKey: gptKey);
final model = ChatOpenAI(apiKey: gptKey, temperature: 0.5,model: 'gpt-3.5-turbo-1106');
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
    print("reached function call");
    setState(() {
      lottiePath = "assets/animations/loading.json";
    });
    print(prompt + ":" + llmResponse);
    const input1 = 'Hi, I am Bob';
    final output1 = await chain.invoke(input1);
    print(output1);
// Hello Bob! How can I assist you today?

    await memory.saveContext(
      inputValues: {'input': input1},
      outputValues: {'output': output1},
    );

    const input2 = "What's my name?";
    final output2 = await chain.invoke(input2);
    print(output2);
// Your name is Bob, as you mentioned earlier.
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(1, 13, 13, 13),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30),
              child: Lottie.asset(lottiePath, height: 375),
            ),
            GestureDetector(
              onTap:
                  _speechToText.isListening ? _stopListening : _startListening,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => stop(),
        child: const Icon(Icons.stop_circle_outlined),
      ),
    );
  }
}
