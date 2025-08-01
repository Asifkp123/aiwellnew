class MoodLogResponse {
  final bool success;
  final String message;
  final int totalCreditsAdded;
  final Map<String, dynamic>? creditSummary;
  final bool acknowledged;

  MoodLogResponse({
    required this.success,
    required this.message,
    required this.totalCreditsAdded,
    this.creditSummary,
    required this.acknowledged,
  });

  factory MoodLogResponse.fromJson(Map<String, dynamic> json) {
    // ✅ Handle the actual API response structure
    final successData = json['success'] as Map<String, dynamic>?;

    if (successData != null) {
      // ✅ Success case - extract data from success object
      final messages = successData['messages'] as List<dynamic>?;
      final firstMessage = messages?.isNotEmpty == true
          ? messages!.first.toString()
          : 'Mood logged successfully!';

      return MoodLogResponse(
        success: true,
        message: firstMessage,
        totalCreditsAdded:
            (successData['total_credits_added'] as num?)?.toInt() ?? 0,
        creditSummary: successData['credit_summary'] as Map<String, dynamic>?,
        acknowledged: successData['acknowledged'] as bool? ?? false,
      );
    } else {
      // ✅ Error case - check for error fields
      return MoodLogResponse(
        success: false,
        message: json['error'] as String? ??
            json['message'] as String? ??
            'Failed to log mood',
        totalCreditsAdded: 0,
        acknowledged: false,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'total_credits_added': totalCreditsAdded,
      'acknowledged': acknowledged,
      if (creditSummary != null) 'credit_summary': creditSummary,
    };
  }

  @override
  String toString() {
    return 'MoodLogResponse(success: $success, message: $message, credits: $totalCreditsAdded)';
  }
}
