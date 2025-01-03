import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoiceActivatedChatbot(),
    );
  }
}

class VoiceActivatedChatbot extends StatefulWidget {
  @override
  _VoiceActivatedChatbotState createState() => _VoiceActivatedChatbotState();
}

class _VoiceActivatedChatbotState extends State<VoiceActivatedChatbot> {
  String _recognizedWords = ''; // Holds the recognized speech text
  bool _isSnackBarActive = false; // Whether the snackbar is visible or not
  String responseText = ''; // To hold the response from AI
  bool _isLoading = false;

  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyAyhEPoeJhtkUEr-ZfopRxJBQTU2y7JAJI',
    systemInstruction: Content.system(
      "Make-A-Ton 7.0: A 24-Hour Hackathon for Innovation and Opportunity.Date: 19th - 20th October, 2024Location: Cochin University of Science and Technology (CUSAT)Welcome to Make-A-Ton 7.0, the ultimate 24-hour hackathon that celebrates creativity, collaboration, and cutting-edge technology. Organized by the Centre for Innovation, Technology Transfer and Industrial Collaboration (CITTIC), this event brings together talented individuals to fuel innovation and build groundbreaking solutions.Why Attend?With an exciting prize pool, cutting-edge gadgets, and coveted internship opportunities, Make-A-Ton 7.0 offers participants the chance to leave their mark on the tech world. Whether you're a seasoned hacker or a beginner, this hackathon is the perfect platform to showcase your skills, learn from others, and create technology that can positively impact the world. Plus, you'll enjoy plenty of coffee, food, swag, and a supportive environment designed to keep your creativity flowing.Key Details:Team Structure: Participants must register in teams of 2-4.Open to All: This event is open to everyone, not just CUSAT students.Hackathon Theme: Make-A-Ton is an open hackathon—no specific theme or marketing focus. Participants are encouraged to build tech solutions that can make a difference.Code of Conduct: The event adheres to the Major League Hacking Code of Conduct, ensuring a welcoming and inclusive atmosphere for all participants.Benefits of Participating:Prizes: Currently, a cash prize of ₹50,000 is confirmed, with more prize details to be announced.Food & Accommodation: All checked-in participants will be provided with meals and a dedicated space to rest.Learning & Networking: Hackathons are great for learning new technologies, networking, and developing friendships with like-minded innovators.Sponsors & Partners:Platinum Sponsors: Orkes, CUSAT Tech FoundationGold Sponsor: GitHubHackathon Partner: Major League Hacking (MLH)Community Partners: Tinker Hun, Google Developer Groups Cochin, IEEE CUSAT SB, and GDS Club CochinFor Beginners:New to coding? No worries! Make-A-Ton welcomes participants of all skill levels. This is a fantastic opportunity to learn, grow, and collaborate with others while building something amazing.Join us at Make-A-Ton 7.0 and be part of an unforgettable 24-hour coding marathon where innovation truly meets opportunity! These are the data related to make a ton 7.0, you are the chat bot of make a ton and created by RUVAIS, so you also answer the questions not related to make aton in  generalised manner, if i ask questions related to make a ton but the data is not in the discription, you replay that 'Refer make a ton website' Organizer phone number Aswin: 8596748596 and Akash: 7859641258",
    ),
  );

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  // Method to generate content based on user input
  Future<void> generateContent(String userInput) async {
    setState(() {
      _isLoading = true; // Start loading
      responseText = ''; // Clear previous response
    });
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
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  // Method to start listening for "Hi hack"
  void _startListening() {
    js.context.callMethod('startSpeechRecognition', [
      "hi hack", // Keyword to activate the chatbot
      () {
        // When "Hi hack" is detected, show the snackbar
        setState(() {
          _isSnackBarActive = true;
        });
      },
      (String recognizedText) {
        // When speech is detected after "Hi hack", hide the snackbar and process the speech
        setState(() {
          _recognizedWords = recognizedText; // Update the recognized words
          _isSnackBarActive = false;
          if (_recognizedWords.isNotEmpty) {
            generateContent(_recognizedWords); // Call AI model
          }
        });

        // Log the recognized text for debugging
        print("Recognized text: $_recognizedWords");

        // Restart the listening process for the next "Hi hack"
        _startListening();
      }
    ]);
  }

  // Method to reset the state back to initial
  void _resetState() {
    setState(() {
      _recognizedWords = ''; // Clear recognized words
      _isSnackBarActive = false; // Hide the snackbar
      responseText = ''; // Clear the response text
    });
    _startListening(); // Restart listening for the keyword
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_recognizedWords.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Recognized: $_recognizedWords',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20), // Space between text and button
                  if (_isLoading) // Show loading indicator if loading
                    CircularProgressIndicator(),
                  if (!_isLoading && responseText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        responseText.replaceAll('*', ''),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  SizedBox(height: 20), // Space between text and button
                  ElevatedButton(
                    onPressed: _resetState, // Reset state when pressed
                    child: Text("OK"),
                  ),
                ],
              )
            else
              _isSnackBarActive
                  ? SizedBox(
                      child: Lottie.network(
                      'https://lottie.host/bf4d2d01-d8a5-407d-97b2-dc49da9f7cd1/2WhmZqWd0g.json',
                    ))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.network(
                            'https://lottie.host/170fdb72-87a7-46a4-a0d0-86642b1ea0fa/cP9KWqHnOf.json',
                            width: 500,
                            height: 500),
                        Lottie.network(
                            'https://lottie.host/170fdb72-87a7-46a4-a0d0-86642b1ea0fa/cP9KWqHnOf.json',
                            width: 500,
                            height: 500),
                      ],
                    )
          ],
        ),
      ),
    );
  }
}
