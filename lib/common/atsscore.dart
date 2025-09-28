import 'dart:convert';

class AtsScoreResult {
  final int score;
  final List<String> matchedKeywords;
  final List<String> toAdd;
  final List<String> toRemove;
  final String message;

  AtsScoreResult({
    required this.score,
    required this.matchedKeywords,
    required this.toAdd,
    required this.toRemove,
    required this.message,
  });

  // Factory constructor to create an AtsScoreResult object from a JSON map
  factory AtsScoreResult.fromJson(Map<String, dynamic> json) {
    return AtsScoreResult(
      score: json['score'] as int,
      // Dart requires explicit casting for lists from JSON
      matchedKeywords: List<String>.from(json['matched_keywords']), 
      toAdd: List<String>.from(json['to_add']),
      toRemove: List<String>.from(json['to_remove']),
      message: json['message'] as String,
    );
  }
}
