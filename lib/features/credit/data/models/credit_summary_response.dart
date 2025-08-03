import '../../domain/entities/credit_summary.dart';

class CreditSummaryResponse {
  final double creditsBalance;
  final double creditsEarned;
  final double creditsSpent;

  CreditSummaryResponse({
    required this.creditsBalance,
    required this.creditsEarned,
    required this.creditsSpent,
  });

  factory CreditSummaryResponse.fromJson(Map<String, dynamic> json) {
    return CreditSummaryResponse(
      creditsBalance: (json['credits_balance'] as num?)?.toDouble() ?? 0.0,
      creditsEarned: (json['credits_earned'] as num?)?.toDouble() ?? 0.0,
      creditsSpent: (json['credits_spent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Convert to domain entity
  CreditSummary toDomainEntity() {
    return CreditSummary(
      creditsBalance: creditsBalance,
      creditsEarned: creditsEarned,
      creditsSpent: creditsSpent,
    );
  }
}
