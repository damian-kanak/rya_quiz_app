import 'package:flutter/material.dart';
import 'sailing_concepts.dart';
import 'quiz_section.dart';

// Color constants
const Color kBackgroundColor = Color.fromRGBO(255, 255, 255, 0.1);
const Color kBorderColor = Color.fromRGBO(255, 255, 255, 0.2);
const Color kTextColor = Color.fromRGBO(255, 255, 255, 0.8);
const Color kDeepBlue = Color(0xFF1B4B82);
const Color kOceanBlue = Color(0xFF2C7DA0);
const Color kWhite = Colors.white;
const Color kSuccessColor = Color(0xFF4CAF50);
const Color kErrorColor = Color(0xFFF44336);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class SailboatSvg extends StatelessWidget {
  const SailboatSvg({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: const Size(200, 200),
        painter: _SailboatPainter(),
      ),
    );
  }
}

class _SailboatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Hull
    final hullPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.7)
      ..lineTo(size.width * 0.8, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.8,
        size.width * 0.8,
        size.height * 0.9,
      )
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height,
        size.width * 0.2,
        size.height * 0.9,
      )
      ..close();
    canvas.drawPath(hullPath, paint);

    // Main sail
    final mainSailPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.7)
      ..lineTo(size.width * 0.5, size.height * 0.2)
      ..lineTo(size.width * 0.7, size.height * 0.4)
      ..lineTo(size.width * 0.5, size.height * 0.7)
      ..close();
    canvas.drawPath(mainSailPath, paint);

    // Front sail
    final frontSailPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.7)
      ..lineTo(size.width * 0.5, size.height * 0.3)
      ..lineTo(size.width * 0.3, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height * 0.7)
      ..close();
    canvas.drawPath(frontSailPath, paint);

    // Mast
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.7),
      Offset(size.width * 0.5, size.height * 0.2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day Skipper Learning',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kDeepBlue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Day Skipper Learning'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kDeepBlue,
              kOceanBlue,
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
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: kWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.quiz, color: kWhite),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => QuizSectionScreen()),
                            );
                          },
                          tooltip: 'Quizzes',
                        ),
                        IconButton(
                          icon: const Icon(Icons.sailing, color: kWhite),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SailingConceptsScreen()),
                            );
                          },
                          tooltip: 'Sailing Concepts',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: Stack(
                  children: [
                    // Main content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: kBackgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: kBorderColor,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Welcome to Day Skipper Learning',
                                  style: TextStyle(
                                    color: kWhite,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Your journey to becoming a competent sailor starts here',
                                  style: TextStyle(
                                    color: kWhite,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SailingConceptsScreen()),
                                        );
                                      },
                                      icon: const Icon(Icons.sailing),
                                      label: const Text('Learn Concepts'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kWhite,
                                        foregroundColor: kDeepBlue,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => QuizSectionScreen()),
                                        );
                                      },
                                      icon: const Icon(Icons.quiz),
                                      label: const Text('Take Quizzes'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kWhite,
                                        foregroundColor: kDeepBlue,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Quick Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStatCard(
                                'Concepts',
                                '5',
                                Icons.book,
                              ),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                'Quizzes',
                                '4',
                                Icons.quiz,
                              ),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                'Progress',
                                '0%',
                                Icons.trending_up,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: kBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: kWhite, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: kWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: kTextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
