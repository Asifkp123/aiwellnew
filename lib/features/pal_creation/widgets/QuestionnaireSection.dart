import 'package:flutter/material.dart';

import '../../../components/text_widgets/text_widgets.dart';

// Main widget
class QuestionnaireSection extends StatelessWidget {
  final String primaryDiagnosis;
  final bool? canWalk;
  final bool? needsWalkingAid;
  final bool? isBedridden;
  final bool? hasDementia;
  final bool? isAgitated;
  final bool? isDepressed;
  final String? dominantEmotion;
  final String? sleepPattern;
  final String? sleepQuality;
  final String? painStatus;

  const QuestionnaireSection({
    super.key,
    required this.primaryDiagnosis,
    required this.canWalk,
    required this.needsWalkingAid,
    required this.isBedridden,
    required this.hasDementia,
    required this.isAgitated,
    required this.isDepressed,
    required this.dominantEmotion,
    required this.sleepPattern,
    required this.sleepQuality,
    required this.painStatus,
  });

  // Helper method to convert bool to display string
  String _boolToDisplayString(bool? value) {
    if (value == null) return 'Not specified';
    return value ? 'Yes' : 'No';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QAItem(
            question: "What is his primary diagnosis?",
            answer: primaryDiagnosis.isNotEmpty
                ? primaryDiagnosis
                : 'Not specified'),
        QAItem(
            question: "Are they able to walk?",
            answer: _boolToDisplayString(canWalk)),
        QAItem(
            question:
                "Do they need a little help to move around, like a walker or stick?",
            answer: _boolToDisplayString(needsWalkingAid)),
        QAItem(
            question:
                "Are they spending most of their time resting in bed these days?",
            answer: _boolToDisplayString(isBedridden)),
        QAItem(
            question:
                "Have you noticed any memory changes or moments of confusion lately?",
            answer: _boolToDisplayString(hasDementia)),
        QAItem(
            question:
                "Have they been feeling uneasy, restless, or a little more sensitive than usual?",
            answer: _boolToDisplayString(isAgitated)),
        QAItem(
            question: "Have they seemed down, quiet, or withdrawn recently?",
            answer: _boolToDisplayString(isDepressed)),
        QAItem(
            question: "What kind of mood have they been in most of the time?",
            answer: dominantEmotion ?? 'Not specified'),
        QAItem(
            question: "What kind of sleep pattern does he have?",
            answer: sleepPattern ?? 'Not specified'),
        QAItem(
            question: "How well have they been sleeping lately?",
            answer: sleepQuality ?? 'Not specified'),
        QAItem(
            question: "Are they feeling any discomfort or pain today?",
            answer: painStatus ?? 'Not specified'),
        const SizedBox(height: 100),
      ],
    );
  }
}

// Custom Q&A item widget
class QAItem extends StatelessWidget {
  final String question;
  final String answer;

  const QAItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Sixteen400GreyText(question),
          const SizedBox(height: 4),
          Sixteen400BlackText(answer),
        ],
      ),
    );
  }
}
