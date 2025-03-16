import 'package:flutter/material.dart';
import 'widgets/chat_bot_dialog.dart';

// Color constants
const Color kBackgroundColor = Color.fromRGBO(255, 255, 255, 0.1);
const Color kBorderColor = Color.fromRGBO(255, 255, 255, 0.2);
const Color kTextColor = Color.fromRGBO(255, 255, 255, 0.8);
const Color kSuccessColor = Color.fromRGBO(0, 255, 0, 0.3);
const Color kErrorColor = Color.fromRGBO(255, 0, 0, 0.3);
const Color kDeepBlue = Color(0xFF1B4B82);
const Color kOceanBlue = Color(0xFF2C7DA0);
const Color kWhite = Colors.white;

class Question {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final String aiExplanation;
  final String nauticalConcepts;
  final String? visualAidType;
  final String? visualAidData;

  const Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.aiExplanation,
    required this.nauticalConcepts,
    this.visualAidType,
    this.visualAidData,
  });
}

class QuizSystem extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Question> questions;

  const QuizSystem({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.questions,
  });

  @override
  State<QuizSystem> createState() => _QuizSystemState();
}

class _QuizSystemState extends State<QuizSystem> with SingleTickerProviderStateMixin {
  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  String? _feedbackMessage;
  Color? _feedbackColor;
  bool _showExplanation = false;
  bool _showNauticalConcepts = false;
  bool _showAIExplanation = false;
  bool _isQuizComplete = false;
  final bool _showQuestionInfo = false;
  String? _aiQuestionRephrasing;
  String? _aiQuestionExplanation;
  int _incorrectAttempts = 0;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _feedbackAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _feedbackController,
        curve: Curves.easeInOut,
      ),
    );
    _loadQuestionInfo();
  }

  Future<void> _loadQuestionInfo() async {
    // Simulate AI service call
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _aiQuestionRephrasing = "Here's another way to think about this: ${widget.questions[_currentQuestionIndex].question}";
        _aiQuestionExplanation = "This question tests your understanding of ${widget.questions[_currentQuestionIndex].question.split(' ').take(5).join(' ')}...";
      });
    }
  }

  @override
  void didUpdateWidget(QuizSystem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questions[_currentQuestionIndex] != widget.questions[_currentQuestionIndex]) {
      _loadQuestionInfo();
    }
  }

  @override
  void dispose() {
    _feedbackController.stop();
    _feedbackController.dispose();
    super.dispose();
  }

  void _resetState() {
    setState(() {
      _selectedAnswer = null;
      _feedbackMessage = null;
      _feedbackColor = null;
      _showExplanation = false;
      _showNauticalConcepts = false;
      _showAIExplanation = false;
      _incorrectAttempts = 0;
      _feedbackController.reset();
    });
  }

  void answerQuestion(int answer) {
    if (_showExplanation) return;
    
    _feedbackController.reset();
    _feedbackController.forward();
    
    setState(() {
      _selectedAnswer = answer;
      final isCorrect = answer == widget.questions[_currentQuestionIndex].correctAnswer;
      _feedbackMessage = isCorrect ? 'Correct!' : 'Incorrect. Try again!';
      _feedbackColor = isCorrect ? kSuccessColor : kErrorColor;
      
      if (isCorrect) {
        _showExplanation = true;
        _incorrectAttempts = 0;
      } else {
        _incorrectAttempts++;
        if (_incorrectAttempts >= 2) {
          _showExplanation = true;
          _feedbackMessage = 'The correct answer is: ${widget.questions[_currentQuestionIndex].options[widget.questions[_currentQuestionIndex].correctAnswer]}';
        }
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _resetState();
      });
    } else {
      setState(() {
        _isQuizComplete = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _isQuizComplete = false;
      _resetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[_currentQuestionIndex];
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

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
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: isSmallScreen ? 8 : 16,
                ),
                decoration: const BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: kWhite),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: kWhite,
                              fontSize: isSmallScreen ? 20 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Question ${_currentQuestionIndex + 1}/${widget.questions.length}',
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / widget.questions.length,
                  backgroundColor: kBorderColor,
                  valueColor: const AlwaysStoppedAnimation<Color>(kWhite),
                  minHeight: 4,
                ),
              ),
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                        decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: kBorderColor,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentQuestion.question,
                              style: TextStyle(
                                color: kWhite,
                                fontSize: isSmallScreen ? 18 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: kTextColor,
                                    size: isSmallScreen ? 20 : 24,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ChatBotDialog(
                                        question: currentQuestion.question,
                                        options: currentQuestion.options,
                                        correctAnswer: currentQuestion.correctAnswer,
                                        explanation: currentQuestion.explanation,
                                        aiExplanation: currentQuestion.aiExplanation,
                                        nauticalConcepts: currentQuestion.nauticalConcepts,
                                      ),
                                    );
                                  },
                                  tooltip: 'Ask Sailing Assistant',
                                ),
                                if (_showQuestionInfo) ...[
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: kBackgroundColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: kBorderColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Alternative Wording:',
                                            style: TextStyle(
                                              color: kWhite,
                                              fontSize: isSmallScreen ? 14 : 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _aiQuestionRephrasing ?? 'Loading...',
                                            style: TextStyle(
                                              color: kTextColor,
                                              fontSize: isSmallScreen ? 14 : 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Question Context:',
                                            style: TextStyle(
                                              color: kWhite,
                                              fontSize: isSmallScreen ? 14 : 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _aiQuestionExplanation ?? 'Loading...',
                                            style: TextStyle(
                                              color: kTextColor,
                                              fontSize: isSmallScreen ? 14 : 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Answer Options
                            ...currentQuestion.options.asMap().entries.map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildAnswerButton(
                                  entry.value,
                                  entry.key,
                                  _selectedAnswer == entry.key,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Feedback
                      if (_feedbackMessage != null)
                        FadeTransition(
                          opacity: _feedbackAnimation,
                          child: Container(
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                            decoration: BoxDecoration(
                              color: _feedbackColor ?? kBackgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _feedbackColor ?? kBorderColor,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _feedbackMessage!,
                                  style: TextStyle(
                                    color: kWhite,
                                    fontSize: isSmallScreen ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_showExplanation) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    currentQuestion.explanation,
                                    style: TextStyle(
                                      color: kWhite,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              _showNauticalConcepts = !_showNauticalConcepts;
                                            });
                                          },
                                          icon: Icon(
                                            _showNauticalConcepts
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            color: kWhite,
                                            size: isSmallScreen ? 20 : 24,
                                          ),
                                          label: Text(
                                            'Nautical Concepts',
                                            style: TextStyle(
                                              color: kWhite,
                                              fontSize: isSmallScreen ? 14 : 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              _showAIExplanation = !_showAIExplanation;
                                            });
                                          },
                                          icon: Icon(
                                            _showAIExplanation
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            color: kWhite,
                                            size: isSmallScreen ? 20 : 24,
                                          ),
                                          label: Text(
                                            'AI Explanation',
                                            style: TextStyle(
                                              color: kWhite,
                                              fontSize: isSmallScreen ? 14 : 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_showNauticalConcepts) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      currentQuestion.nauticalConcepts,
                                      style: TextStyle(
                                        color: kWhite,
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                    ),
                                  ],
                                  if (_showAIExplanation) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      currentQuestion.aiExplanation,
                                      style: TextStyle(
                                        color: kWhite,
                                        fontSize: isSmallScreen ? 14 : 16,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _nextQuestion,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kWhite,
                                            foregroundColor: kDeepBlue,
                                            padding: EdgeInsets.symmetric(
                                              vertical: isSmallScreen ? 12 : 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            _currentQuestionIndex < widget.questions.length - 1
                                                ? 'Continue'
                                                : 'Finish Quiz',
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 14 : 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      // Quiz Complete
                      if (_isQuizComplete)
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
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
                              Icon(
                                Icons.check_circle,
                                color: kSuccessColor,
                                size: isSmallScreen ? 48 : 64,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Quiz Complete!',
                                style: TextStyle(
                                  color: kWhite,
                                  fontSize: isSmallScreen ? 20 : 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'You\'ve completed all questions in this quiz.',
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _restartQuiz,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kWhite,
                                    foregroundColor: kDeepBlue,
                                    padding: EdgeInsets.symmetric(
                                      vertical: isSmallScreen ? 12 : 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Restart Quiz',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildAnswerButton(String text, int index, bool isSelected) {
    final isCorrect = index == widget.questions[_currentQuestionIndex].correctAnswer;
    final showFeedback = _selectedAnswer != null;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showExplanation ? null : () => answerQuestion(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            color: showFeedback
                ? (isCorrect
                    ? kSuccessColor
                    : (isSelected ? kErrorColor : kBackgroundColor))
                : (isSelected ? kBorderColor : kBackgroundColor),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: showFeedback
                  ? (isCorrect
                      ? kSuccessColor
                      : (isSelected ? kErrorColor : kBorderColor))
                  : (isSelected ? kWhite : kBorderColor),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: isSmallScreen ? 20 : 24,
                height: isSmallScreen ? 20 : 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: showFeedback
                        ? (isCorrect
                            ? kWhite
                            : (isSelected ? kWhite : kBorderColor))
                        : (isSelected ? kWhite : kBorderColor),
                    width: 2,
                  ),
                ),
                child: showFeedback && isCorrect
                    ? Icon(
                        Icons.check,
                        color: kWhite,
                        size: isSmallScreen ? 14 : 16,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: showFeedback
                        ? (isCorrect || isSelected ? kWhite : kTextColor)
                        : (isSelected ? kWhite : kTextColor),
                    fontSize: isSmallScreen ? 14 : 16,
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