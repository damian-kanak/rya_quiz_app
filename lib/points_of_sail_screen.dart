import 'package:flutter/material.dart';

class PointOfSail {
  final String name;
  final String description;
  final double angleFromWind;
  final String characteristics;

  PointOfSail({
    required this.name,
    required this.description,
    required this.angleFromWind,
    required this.characteristics,
  });
}

class PointsOfSailScreen extends StatefulWidget {
  const PointsOfSailScreen({super.key});

  @override
  State<PointsOfSailScreen> createState() => _PointsOfSailScreenState();
}

class _PointsOfSailScreenState extends State<PointsOfSailScreen> {
  final List<PointOfSail> pointsOfSail = [
    PointOfSail(
      name: 'Close Hauled',
      description: 'Sailing as close to the wind as possible, typically at 30-45 degrees to the wind.',
      angleFromWind: 45,
      characteristics: '• Highest pointing angle\n• Sails pulled in tight\n• Boat heels significantly\n• Slower speed but best upwind progress',
    ),
    PointOfSail(
      name: 'Close Reach',
      description: 'Sailing between close-hauled and beam reach, at about 60-75 degrees to the wind.',
      angleFromWind: 60,
      characteristics: '• Good balance of speed and pointing\n• Sails slightly eased\n• Moderate heel\n• Efficient upwind sailing',
    ),
    PointOfSail(
      name: 'Beam Reach',
      description: 'Sailing perpendicular to the wind, at 90 degrees.',
      angleFromWind: 90,
      characteristics: '• Fastest point of sail\n• Sails half out\n• Moderate heel\n• Most efficient sailing angle',
    ),
    PointOfSail(
      name: 'Broad Reach',
      description: 'Sailing between beam reach and running, at about 120-135 degrees to the wind.',
      angleFromWind: 135,
      characteristics: '• Fast sailing\n• Sails well out\n• Less heel\n• Good downwind speed',
    ),
    PointOfSail(
      name: 'Running',
      description: 'Sailing directly downwind, at 180 degrees to the wind.',
      angleFromWind: 180,
      characteristics: '• Sails fully out\n• No heel\n• Can be unstable\n• Spinnaker often used',
    ),
  ];

  int currentQuestionIndex = 0;
  int score = 0;
  bool quizStarted = false;
  bool quizCompleted = false;

  final List<Map<String, dynamic>> quizQuestions = [
    {
      'question': 'Which point of sail is typically the fastest?',
      'options': ['Close Hauled', 'Beam Reach', 'Broad Reach', 'Running'],
      'correctAnswer': 1,
    },
    {
      'question': 'At which angle to the wind do you sail when close-hauled?',
      'options': ['30-45 degrees', '60-75 degrees', '90 degrees', '120-135 degrees'],
      'correctAnswer': 0,
    },
    {
      'question': 'Which point of sail has the most heel?',
      'options': ['Running', 'Beam Reach', 'Close Hauled', 'Broad Reach'],
      'correctAnswer': 2,
    },
    {
      'question': 'When running, what is the angle to the wind?',
      'options': ['90 degrees', '135 degrees', '180 degrees', '45 degrees'],
      'correctAnswer': 2,
    },
  ];

  void startQuiz() {
    setState(() {
      quizStarted = true;
      currentQuestionIndex = 0;
      score = 0;
      quizCompleted = false;
    });
  }

  void answerQuestion(int selectedAnswer) {
    if (selectedAnswer == quizQuestions[currentQuestionIndex]['correctAnswer']) {
      score++;
    }

    if (currentQuestionIndex < quizQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      setState(() {
        quizCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B4B82), // Deep blue
              Color(0xFF2C7DA0), // Ocean blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Points of Sail',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!quizStarted && !quizCompleted) ...[
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color.fromRGBO(255, 255, 255, 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Points of Sail Definitions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ...pointsOfSail.map((point) => Container(
                                    margin: const EdgeInsets.only(bottom: 24),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(255, 255, 255, 0.1),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: const Color.fromRGBO(255, 255, 255, 0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          point.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          point.description,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Angle to wind: ${point.angleFromWind}°',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Characteristics:',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          point.characteristics,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: startQuiz,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF1B4B82),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Start Quiz'),
                          ),
                        ),
                      ],
                      if (quizStarted && !quizCompleted) ...[
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color.fromRGBO(255, 255, 255, 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Question ${currentQuestionIndex + 1}/${quizQuestions.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                quizQuestions[currentQuestionIndex]['question'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ...List.generate(
                                quizQuestions[currentQuestionIndex]['options'].length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ElevatedButton(
                                    onPressed: () => answerQuestion(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF1B4B82),
                                      minimumSize: const Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text(
                                      quizQuestions[currentQuestionIndex]['options'][index],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (quizCompleted) ...[
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color.fromRGBO(255, 255, 255, 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Quiz Completed!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Your score: $score/${quizQuestions.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    quizStarted = false;
                                    quizCompleted = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1B4B82),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text('Back to Definitions'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 