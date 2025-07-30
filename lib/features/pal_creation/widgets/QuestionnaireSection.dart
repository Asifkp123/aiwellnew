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
  final String? gender; // Added gender parameter

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
    this.gender, // Added gender parameter
  });

  // Helper method to convert bool to display string
  String _boolToDisplayString(bool? value) {
    if (value == null) return 'Not specified';
    return value ? 'Yes' : 'No';
  }

  // Helper methods for gender-based pronouns
  String _getSubjectPronoun() {
    switch (gender?.toLowerCase()) {
      case 'male':
        return 'he';
      case 'female':
        return 'she';
      default:
        return 'they';
    }
  }

  String _getObjectPronoun() {
    switch (gender?.toLowerCase()) {
      case 'male':
        return 'him';
      case 'female':
        return 'her';
      default:
        return 'them';
    }
  }

  String _getPossessivePronoun() {
    switch (gender?.toLowerCase()) {
      case 'male':
        return 'his';
      case 'female':
        return 'her';
      default:
        return 'their';
    }
  }

  String _getVerbForm(String singular, String plural) {
    return (gender?.toLowerCase() == 'male' || gender?.toLowerCase() == 'female') 
        ? singular 
        : plural;
  }

  // Helper method to generate gender-specific questions
  String _getDiagnosisQuestion() {
    return gender?.toLowerCase() == 'male'
        ? "What is his primary diagnosis?"
        : gender?.toLowerCase() == 'female'
            ? "What is her primary diagnosis?"
            : "What is their primary diagnosis?";
  }

  String _getWalkingQuestion() {
    return "${_getVerbForm('Is', 'Are')} ${_getSubjectPronoun()} able to walk?";
  }

  String _getWalkingAidQuestion() {
    return "${_getVerbForm('Does', 'Do')} ${_getSubjectPronoun()} need a little help to move around, like a walker or stick?";
  }

  String _getBedRestQuestion() {
    return "${_getVerbForm('Is', 'Are')} ${_getSubjectPronoun()} spending most of ${_getPossessivePronoun()} time resting in bed these days?";
  }

  String _getMemoryQuestion() {
    return "Have you noticed any memory changes or moments of confusion in ${_getObjectPronoun()} lately?";
  }

  String _getAgitationQuestion() {
    return "${_getVerbForm('Has', 'Have')} ${_getSubjectPronoun()} been feeling uneasy, restless, or a little more sensitive than usual?";
  }

  String _getDepressionQuestion() {
    return "${_getVerbForm('Has', 'Have')} ${_getSubjectPronoun()} seemed down, quiet, or withdrawn recently?";
  }

  String _getMoodQuestion() {
    return "What kind of mood ${_getVerbForm('has', 'have')} ${_getSubjectPronoun()} been in most of the time?";
  }

  String _getSleepPatternQuestion() {
    return "What kind of sleep pattern ${_getVerbForm('does', 'do')} ${_getSubjectPronoun()} have?";
  }

  String _getSleepQualityQuestion() {
    return "How well ${_getVerbForm('has', 'have')} ${_getSubjectPronoun()} been sleeping lately?";
  }

  String _getPainQuestion() {
    return "${_getVerbForm('Is', 'Are')} ${_getSubjectPronoun()} feeling any discomfort or pain today?";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QAItem(
            question: _getDiagnosisQuestion(),
            answer: primaryDiagnosis.isNotEmpty
                ? primaryDiagnosis
                : 'Not specified'),
        QAItem(
            question: _getWalkingQuestion(),
            answer: _boolToDisplayString(canWalk)),
        QAItem(
            question: _getWalkingAidQuestion(),
            answer: _boolToDisplayString(needsWalkingAid)),
        QAItem(
            question: _getBedRestQuestion(),
            answer: _boolToDisplayString(isBedridden)),
        QAItem(
            question: _getMemoryQuestion(),
            answer: _boolToDisplayString(hasDementia)),
        QAItem(
            question: _getAgitationQuestion(),
            answer: _boolToDisplayString(isAgitated)),
        QAItem(
            question: _getDepressionQuestion(),
            answer: _boolToDisplayString(isDepressed)),
        QAItem(
            question: _getMoodQuestion(),
            answer: dominantEmotion ?? 'Not specified'),
        QAItem(
            question: _getSleepPatternQuestion(),
            answer: sleepPattern ?? 'Not specified'),
        QAItem(
            question: _getSleepQualityQuestion(),
            answer: sleepQuality ?? 'Not specified'),
        QAItem(
            question: _getPainQuestion(),
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
