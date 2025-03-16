import 'package:flutter/material.dart';
import '../services/ai_service.dart';

// Color constants
const Color kBackgroundColor = Color.fromRGBO(255, 255, 255, 0.1);
const Color kBorderColor = Color.fromRGBO(255, 255, 255, 0.2);
const Color kTextColor = Color.fromRGBO(255, 255, 255, 0.8);
const Color kDeepBlue = Color(0xFF1B4B82);
const Color kOceanBlue = Color(0xFF2C7DA0);
const Color kWhite = Colors.white;
const Color kSuccessColor = Color(0xFF4CAF50);
const Color kErrorColor = Color(0xFFF44336);

class ChatBotDialog extends StatefulWidget {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final String aiExplanation;
  final String nauticalConcepts;

  const ChatBotDialog({
    super.key,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.aiExplanation,
    required this.nauticalConcepts,
  });

  @override
  State<ChatBotDialog> createState() => _ChatBotDialogState();
}

class _ChatBotDialogState extends State<ChatBotDialog> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      "Hi! I'm your AI sailing assistant. I can help explain this question and any nautical terms you're curious about. What would you like to know?",
    );
    _addBotMessage(
      "This question is about: ${widget.question}",
      isQuestion: true,
    );
    _addBotMessage(
      "The options are:\n${widget.options.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}",
      isQuestion: true,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addBotMessage(String message, {bool isQuestion = false, bool isError = false}) {
    setState(() {
      _messages.add({
        'text': message,
        'isUser': false,
        'isQuestion': isQuestion,
        'isError': isError,
      });
    });
    _scrollToBottom();
  }

  void _addUserMessage(String message) {
    setState(() {
      _messages.add({
        'text': message,
        'isUser': true,
        'isQuestion': false,
        'isError': false,
      });
      _hasError = false;
      _errorMessage = null;
    });
    _scrollToBottom();
    _getAIResponse(message);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _getAIResponse(String userMessage) async {
    setState(() => _isLoading = true);
    try {
      final response = await AIService.getResponse(
        question: widget.question,
        options: widget.options,
        correctAnswer: widget.correctAnswer,
        explanation: widget.explanation,
        aiExplanation: widget.aiExplanation,
        nauticalConcepts: widget.nauticalConcepts,
        userMessage: userMessage,
      );
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _messages.add({
            'text': response,
            'isUser': false,
            'isQuestion': false,
            'isError': false,
          });
        });
        _scrollToBottom();
      }
    } on AIException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = _getUserFriendlyErrorMessage(e);
          _messages.add({
            'text': _errorMessage!,
            'isUser': false,
            'isQuestion': false,
            'isError': true,
          });
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'An unexpected error occurred. Please try again later.';
          _messages.add({
            'text': _errorMessage!,
            'isUser': false,
            'isQuestion': false,
            'isError': true,
          });
        });
        _scrollToBottom();
      }
    }
  }

  String _getUserFriendlyErrorMessage(AIException e) {
    switch (e.code) {
      case 'API_KEY_MISSING':
        return 'I apologize, but there seems to be a configuration issue. Please contact support.';
      case 'NETWORK_ERROR':
        return 'I\'m having trouble connecting to the server. Please check your internet connection and try again.';
      case 'INVALID_RESPONSE':
        return 'I received an unexpected response. Please try rephrasing your question.';
      case 'API_ERROR_401':
        return 'There seems to be an authentication issue. Please contact support.';
      case 'API_ERROR_429':
        return 'I\'m receiving too many requests right now. Please wait a moment and try again.';
      case 'API_ERROR_500':
        return 'The server is experiencing issues. Please try again in a few minutes.';
      default:
        return 'I encountered an error while processing your request. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: isSmallScreen ? screenHeight * 0.8 : screenHeight * 0.7,
        decoration: BoxDecoration(
          color: kDeepBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sailing, color: kWhite),
                  const SizedBox(width: 8),
                  Text(
                    'Sailing Assistant',
                    style: TextStyle(
                      color: kWhite,
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: kWhite),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Chat Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message['isUser']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: message['isUser']
                            ? kOceanBlue
                            : (message['isQuestion']
                                ? kSuccessColor
                                : message['isError']
                                    ? kErrorColor
                                    : kBackgroundColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(
                          color: kWhite,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Input Area
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
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: kWhite),
                      decoration: InputDecoration(
                        hintText: _hasError ? 'Try asking again...' : 'Ask about sailing terms...',
                        hintStyle: const TextStyle(color: kTextColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kBorderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kWhite),
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _addUserMessage(value);
                          _messageController.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(kWhite),
                            ),
                          )
                        : const Icon(Icons.send, color: kWhite),
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_messageController.text.trim().isNotEmpty) {
                              _addUserMessage(_messageController.text);
                              _messageController.clear();
                            }
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 