class AIException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AIException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AIException: $message${code != null ? ' (Code: $code)' : ''}';
}

class AIService {
  // Local response generator for quiz questions and nautical terms
  // All processing happens on device without external API calls
  
  static Future<String> getResponse({
    required String question,
    required List<String> options,
    required int correctAnswer,
    required String explanation,
    required String aiExplanation,
    required String nauticalConcepts,
    required String userMessage,
  }) async {
    // For now, return a local response to avoid API issues
    return _generateLocalResponse(
      question: question,
      options: options,
      correctAnswer: correctAnswer,
      explanation: explanation,
      aiExplanation: aiExplanation,
      nauticalConcepts: nauticalConcepts,
      userMessage: userMessage,
    );
  }

  static String _generateLocalResponse({
    required String question,
    required List<String> options,
    required int correctAnswer,
    required String explanation,
    required String aiExplanation,
    required String nauticalConcepts,
    required String userMessage,
  }) {
    final lowerMessage = userMessage.toLowerCase().trim();
    
    // First, try to extract a specific nautical term
    String? searchTerm;
    
    // Common patterns for asking about terms
    final patterns = [
      RegExp(r'what\s+is\s+(?:a\s+)?([a-zA-Z\s]+)\??$'),
      RegExp(r'meaning\s+of\s+([a-zA-Z\s]+)\??$'),
      RegExp(r'define\s+([a-zA-Z\s]+)\??$'),
      RegExp(r'explain\s+([a-zA-Z\s]+)\??$'),
      RegExp(r'tell\s+me\s+about\s+([a-zA-Z\s]+)\??$'),
    ];
    
    // Try each pattern
    for (final pattern in patterns) {
      final match = pattern.firstMatch(lowerMessage);
      if (match != null) {
        searchTerm = match.group(1)?.trim();
        break;
      }
    }
    
    // If no pattern matched but the message is short and contains 'what' and 'is',
    // try to extract the term directly
    if (searchTerm == null && 
        lowerMessage.length < 30 && 
        lowerMessage.contains('what') && 
        lowerMessage.contains('is')) {
      final words = lowerMessage.split(' ');
      final lastWord = words.last.replaceAll('?', '');
      if (lastWord.length > 2) {  // Avoid too short terms
        searchTerm = lastWord;
      }
    }
    
    // If we found a term to search for
    if (searchTerm != null) {
      // Split nautical concepts into sentences
      final conceptSentences = nauticalConcepts
          .split('.')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
          
      // Find sentences containing the search term
      final relevantConcepts = conceptSentences
          .where((s) => s.toLowerCase().contains(searchTerm!.toLowerCase()))
          .toList();
          
      if (relevantConcepts.isNotEmpty) {
        if (relevantConcepts.length == 1) {
          return relevantConcepts.first;
        }
        return 'Here\'s what I found about "$searchTerm":\n\n${relevantConcepts.map((s) => '• $s').join('\n')}';
      } else {
        // If no exact match found, try to find sentences with similar terms
        final similarConcepts = conceptSentences
            .where((s) => searchTerm!.split(' ').any((word) => 
                word.length > 2 && s.toLowerCase().contains(word.toLowerCase())))
            .toList();
            
        if (similarConcepts.isNotEmpty) {
          return 'I found some related information:\n\n${similarConcepts.map((s) => '• $s').join('\n')}';
        }
        
        return 'I don\'t have specific information about "$searchTerm" in the current context. Would you like me to explain the question in general, or help with something else?';
      }
    }

    // Check if asking about the correct answer
    if (lowerMessage.contains('correct answer') ||
        lowerMessage.contains('right answer') ||
        lowerMessage.contains('solution')) {
      return 'The correct answer is: ${options[correctAnswer]}.\n\nHere\'s why: $explanation';
    }

    // Check if asking for an explanation
    if (lowerMessage.contains('explain') ||
        lowerMessage.contains('why') ||
        lowerMessage.contains('how') ||
        lowerMessage.contains('help me understand')) {
      return 'Let me explain this in detail:\n\n$aiExplanation\n\nThe key points to remember are:\n${explanation.split('.').where((s) => s.trim().isNotEmpty).map((s) => '• ${s.trim()}').join('\n')}';
    }

    // Check if asking about nautical concepts or terms
    if (lowerMessage.contains('what') ||
        lowerMessage.contains('mean') ||
        lowerMessage.contains('term') ||
        lowerMessage.contains('concept') ||
        lowerMessage.contains('define')) {
      if (lowerMessage.length > 20) {
        // If the question is specific, try to find relevant parts of the nautical concepts
        final terms = nauticalConcepts.split('.')
            .where((s) => s.trim().isNotEmpty)
            .where((s) => lowerMessage.split(' ')
                .any((word) => word.length > 3 && s.toLowerCase().contains(word)))
            .map((s) => s.trim());
            
        if (terms.isNotEmpty) {
          return 'Here are the relevant nautical concepts:\n\n${terms.map((s) => '• $s').join('\n')}';
        }
      }
      return 'Here are all the nautical concepts related to this question:\n\n${nauticalConcepts.split('.').where((s) => s.trim().isNotEmpty).map((s) => '• ${s.trim()}').join('\n')}';
    }

    // Check if asking about specific options
    for (var i = 0; i < options.length; i++) {
      if (lowerMessage.contains(options[i].toLowerCase())) {
        if (i == correctAnswer) {
          return 'Yes, "${options[i]}" is the correct answer! $explanation';
        } else {
          return 'While "${options[i]}" is not the correct answer, it\'s a good thought. Would you like me to explain why a different option might be better?';
        }
      }
    }

    // Check if it's a greeting or introduction
    if (lowerMessage.contains('hi') ||
        lowerMessage.contains('hello') ||
        lowerMessage.contains('hey')) {
      return 'Hello! I\'m here to help you understand this question about ${question.split(' ').take(5).join(' ')}... What specific aspect would you like me to explain?';
    }

    // Check if asking about the question itself
    if (lowerMessage.contains('question') ||
        lowerMessage.contains('understand') ||
        lowerMessage.contains('confused')) {
      return 'Let me break down this question for you:\n\n${aiExplanation.split('.').where((s) => s.trim().isNotEmpty).map((s) => '• ${s.trim()}').join('\n')}\n\nWhat specific part would you like me to clarify?';
    }

    // Default response with context
    return 'I can help you understand this question about ${question.split(' ').take(5).join(' ')}... Would you like me to:\n\n• Explain the correct answer\n• Break down the key concepts\n• Define any nautical terms\n• Provide more detailed reasoning\n\nJust let me know what would be most helpful!';
  }
} 