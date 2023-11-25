import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:langchain_chroma/langchain_chroma.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:avatar_glow/avatar_glow.dart';

final llm = OpenAI(apiKey: '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');
final chatModel = ChatOpenAI(apiKey: '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',temperature: 0.2,model: 'gpt-3.5-turbo-0613');
final embeddings = OpenAIEmbeddings(apiKey: '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',baseUrl: '');
const stringOutputParser = StringOutputParser();
final memory = ConversationBufferMemory(returnMessages: true);

  final vectorStore = Chroma(embeddings: embeddings);
  final retriever = vectorStore.asRetriever();

final promptTemplate = ChatPromptTemplate.fromPromptMessages([
  SystemChatMessagePromptTemplate.fromTemplate(
    'AI Bot named SairamX', //Role Assigned
  ),
  const MessagesPlaceholder(variableName: 'history'),
  HumanChatMessagePromptTemplate.fromTemplate('{input}'),
]);

final chain = Runnable.fromMap({
      'context': retriever | Runnable.fromFunction((docs, _) => docs.join('\n')),
  'question': Runnable.passthrough(),
}) | promptTemplate | chatModel | const StringOutputParser();


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
    setState(() {
    });
    chroma_DB();
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
    //llmResponse = await llm.predict("Can I jump from 11th floor into swimming pool?");
    final llmResponse = await chain.invoke(prompt);
    print(prompt+":"+llmResponse);

    await memory.saveContext(
    inputValues: {'input': prompt},
    outputValues: {'output': llmResponse},
    );  
    print("Context Saved");
    play(llmResponse);
  }

  void chroma_DB() async{ 
    await vectorStore.addDocuments(
    documents: const [
    Document(pageContent: 'Sri Sairam Techno Incubation Foundation was established on 12th September 2020. '),
    Document(pageContent: 'The thrust areas are Solid Waste Management (SWM), Defence, Robotics, Agriculture, Drones, Healthcare & Additive manufacturing. Startups Incubated -85, Women Startups -14, Defense startups -2, Startups Graduated-17'),
    Document(pageContent: 'vision of sairam Incubation: To be a center of excellence that construct a dynamic and sustainable ecosystem for enriching Entrepreneurship Skills.'),
    Document(pageContent: 'objectives: Enhance the graduate engineers knowledge to suit the industry requirements. Ready to adopt industry culture. Make students aware of latest technology and understand the processes of developing a true product.'),
    Document(pageContent: 'mission: We are Committed to nurture creativity, innovation and entrepreneurship among students, Faculty and aspirants. We strongly cultivate industrial culture and standards.We enable process for developing ideas into products.'),
    Document(pageContent: 'Projects: Pendulum hand pump, Avian Incubator, Pond quality monitoring system, remotely operated underwater vehicle, bookvia, Automation & Monitoring system for mushroom cultivation, Automation of fireextinguisher'),
    Document(pageContent: 'Pendulum Hand Pump: Deep well handpump cause discomfort and fatigue to the user after long hours of operation. To overcome this problem a pendulum incorporated hand pump design was made and fabricated. The prototype built was far more effective and easier to use than the normal pump.The long-pivoted shaft is replaced by a pendulum which provides exact torque needed to rise the piston up. The pendulum oscillates with minimum force applied. This design uses the energy stored in the pendulum as an advantage. In this design six strokes can be achieved with an initial force.'),
    Document(pageContent: 'Avian incubator: An incubator is a device simulating avian incubation method by keeping eggs warm at an optimum temperature and humidity using a turning mechanism to hatch them.The thermo-electricity theory governs the functioning of an incubator. The incubator uses a thermostat that provides a thermal gradient to maintain a consistent temperature and humidity.'),
    Document(pageContent: 'Pond quality monitoring system: There has been a recent increase in deaths of marine animals by 183%. This is an unprecedented consequence of the lack of control that we exert over our ponds and water bodies. To avoid this condition, we require constant monitoring of these marine habitats to ensure the safety and health of our fish friends. This particular project aims at monitoring a population of Koi fish living in Sri Sairam Engineering College.We employ a combination of a kiosk and a probing buoy floating on the surface of water containing different sensors. The kiosk informs the user about various parameters and the status of the pond'),
    Document(pageContent: 'Remotely operated underwater Vehicle: shortly ROUV is Developed for supporting the Aquaculture Farms. For solving Outdated Cage Maintenance Methods. Traditional human assessments are time-expensive and ineffective. For controlling Disease and Poor Water Quality. Cage ecosystems are jeopardized by water hygiene issues left uncheckedUniqueness:→Multiple Sensors & Fixture Integration→10 kg Payload Capacity→Long Battery Life - 2 to 3 Hours→Up to 2 Knots speed, Low Light HD Camera for nighttime inspection & 100m Depth'),
    Document(pageContent: "bookvia:Bookiva is a web application for reservations of college accommodations which works on any type of devices and will automatically detect and prevent users from booking rooms that have already been occupied for a cause. This preemptive method of detection and prevention eliminates the majority of office productivity related problems of having to find a vacant room. The major goal of this system is to totally digitise the records and eliminate the need for manual booking.The user's room name and slot parameters are read from the user. The slot is compared to all other slots booked for that room on that exact day. If the session does not overlap with any other, it is available for booking. The booked slots details are stored in database and can be read from it"),
    Document(pageContent: 'Automation & Monitoring system for mushroom cultivation:provide setups and methods to promote agriculture and make it more automated and technological'),
    Document(pageContent: 'Automation of fire extinguisher: - This Project mainly focus on the solution to the fire accidents occur in textile shops, warehouses and industries. Fire accidents occur due to various reasons like electrical shortages, human mistakes or other accidents. Majority of cases happens during night, which lead to unaware situation for the respective owners. This project ultimate goal is to build a deep learning model which will collect the real time data from cameras and analyse the depth using distance measuring software at which the fire accident occurs with that details our model will interact with microcontroller to smartly accutate the water / fire extinguishers based on the materials present in the accident prone zone.Below there is the brief working detail about one of the module of my project (ie) fire detecting using yolo is mentioned. In order to track the fire, The project must follow below steps'),
    Document(pageContent: 'Our Team: Dr Sai Prakash leo muthu CEO sairam Institutions'),
    Document(pageContent: ''),
    Document(pageContent: ''),
    Document(pageContent: ''),
    Document(pageContent: ''),

  ],
);

  }

  void play(response) async {
    await flutterTts.setLanguage('en-in');
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(response);
    // flutterTts.setCompletionHandler(() {
    //     setState(() {
    //       llmResponse="";
    //     });
    // });
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

