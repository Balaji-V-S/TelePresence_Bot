import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';
// import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:avatar_glow/avatar_glow.dart';

final llm = OpenAI(apiKey: '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');
final chatModel = ChatOpenAI(apiKey: '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');

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

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initSpeech();
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
    llmResponse = await llm.predict("Tell me a joke!");
    print(prompt + ":" + llmResponse); // 'Hello!'
    play(llmResponse);
  }

  void play(response) async {
    await flutterTts.setLanguage('en-in');
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(response);
    flutterTts.setCompletionHandler(() {
        setState(() {
          llmResponse="";
        });
    });
  }

  // void stop() async{
  //   await flutterTts.stop();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30),
              child: Lottie.asset('assets/animations/droid.json',height: 375),
            ),
            GestureDetector(
              onTap: _speechToText.isListening ? _stopListening : _startListening,
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
            _speechToText.isListening?
            LottieBuilder.asset('assets/animations/micInitialized.json')
            :const Padding(
              padding: EdgeInsets.only(bottom:30),
              child: Text("Not Initialised"),
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
    );
  }
}
