import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text_google_dialog/speech_to_text_google_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool state = false;
  String responseText = ''; // Variable to hold the AI response
  String speechResult = ''; // Variable to hold the speech-to-text result

  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyAyhEPoeJhtkUEr-ZfopRxJBQTU2y7JAJI',
    systemInstruction: Content.system(
        "Make-A-Ton 7.0: A 24-Hour Hackathon for Innovation and Opportunity.Date: 19th - 20th October, 2024Location: Cochin University of Science and Technology (CUSAT)..."),
  );

  final TextEditingController _controller =
      TextEditingController(); // Controller for input

  // Function to call the AI model
  Future<void> generateContent(String userInput) async {
    try {
      final contents = [Content.text(userInput)];
      final result = await model.generateContent(contents);
      setState(() {
        responseText = result.text.toString(); // Display the response
      });
    } catch (e) {
      setState(() {
        responseText = 'Error: $e';
      });
    }
  }

  // Speech to text function
  Future<void> startSpeechToText() async {
    bool isServiceAvailable =
        await SpeechToTextGoogleDialog.getInstance().showGoogleDialog(
      onTextReceived: (data) {
        setState(() {
          speechResult = data.toString(); // Update speech result
          _controller.text =
              speechResult; // Update the text field with speech input
        });
      },
    );

    if (!isServiceAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Speech service is not available'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 16,
          right: 16,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            // Background image
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/assets/image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Toggle between input and response states
            state
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 300,
                      height: 300,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: Colors.yellow),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(responseText), // Display the AI response
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                state = !state; // Toggle state back
                              });
                            },
                            child: Container(
                              width: 80,
                              height: 50,
                              color: Colors.black,
                              child: const Center(
                                child: Text(
                                  "Ask Again",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _controller, // Attach controller
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                String userInput = _controller.text;
                                if (userInput.isNotEmpty) {
                                  await generateContent(
                                      userInput); // Call AI model
                                  setState(() {
                                    state =
                                        !state; // Toggle state to show response
                                  });
                                }
                              },
                              child: Container(
                                width: 80,
                                height: 50,
                                color: Colors.black,
                                child: const Center(
                                  child: Text(
                                    "Ask",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed:
                                  startSpeechToText, // Start speech-to-text
                              child: const Text('Speech'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
