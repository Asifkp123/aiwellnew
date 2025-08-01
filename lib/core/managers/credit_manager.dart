import 'package:flutter/foundation.dart';

class CreditManager extends ChangeNotifier {
  static final CreditManager _instance = CreditManager._internal();
  static CreditManager get instance => _instance;

  CreditManager._internal();

  int _totalCredits = 0;
  int get totalCredits => _totalCredits;

  /// Updates credits from API responses that contain "total_credits_added"
  void updateCreditsFromResponse(Map<String, dynamic> response) {
    if (response.containsKey('total_credits_added')) {
      final creditsAdded = response['total_credits_added'] as int? ?? 0;
      _totalCredits += creditsAdded;
      notifyListeners();
      print('💰 Credits added: $creditsAdded, Total: $_totalCredits');
    }
  }

  /// Set total credits directly (useful for initialization from user profile)
  void setTotalCredits(int credits) {
    _totalCredits = credits;
    notifyListeners();
  }

  /// Add credits manually
  void addCredits(int credits) {
    _totalCredits += credits;
    notifyListeners();
  }

  /// Reset credits (for logout scenarios)
  void resetCredits() {
    _totalCredits = 0;
    notifyListeners();
  }
}
