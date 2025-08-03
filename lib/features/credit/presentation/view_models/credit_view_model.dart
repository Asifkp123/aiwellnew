import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/usecases/get_credit_summary_use_case.dart';
import '../../../../core/network/http_api_services.dart';
import '../../data/datasources/remote/credit_remote_datasource.dart';
import '../../data/repositories/credit_summary_repository.dart';

enum CreditStatus { idle, loading, success, error }

class CreditState {
  final CreditStatus status;
  final int totalCredits;
  final String? errorMessage;
  final int? creditsAdded;

  CreditState({
    required this.status,
    required this.totalCredits,
    this.errorMessage,
    this.creditsAdded,
  });
}

abstract class CreditViewModelBase {
  Stream<CreditState> get stateStream;
  Future<void> loadCredits();
  Future<void> addCreditsFromLog(int creditsAdded);
  void dispose();
}

class CreditViewModel implements CreditViewModelBase {
  final GetCreditSummaryUseCase getCreditSummaryUseCase;

  final StreamController<CreditState> _stateController =
      StreamController<CreditState>.broadcast();

  // Track current credits internally
  int _currentCredits = 0;

  CreditViewModel({
    required this.getCreditSummaryUseCase,
  }) {
    // Initialize with zero credits
    _emitState(CreditState(
      status: CreditStatus.idle,
      totalCredits: _currentCredits,
    ));
  }

  @override
  Stream<CreditState> get stateStream => _stateController.stream;

  /// Load credits from server
  @override
  Future<void> loadCredits() async {
    _emitState(CreditState(
      status: CreditStatus.loading,
      totalCredits: _currentCredits,
    ));

    final result = await getCreditSummaryUseCase.execute();

    result.fold(
      (failure) {
        _emitState(CreditState(
          status: CreditStatus.error,
          totalCredits: _currentCredits,
          errorMessage: failure.message,
        ));
      },
      (creditSummary) {
        // Update internal state and emit
        _currentCredits = creditSummary.creditsBalance.toInt();
        _emitState(CreditState(
          status: CreditStatus.success,
          totalCredits: _currentCredits,
        ));
      },
    );
  }

  /// Add credits from log success (with UI update)
  @override
  Future<void> addCreditsFromLog(int creditsAdded) async {
    // Update internal state
    _currentCredits += creditsAdded;

    // Emit state change for UI
    _emitState(CreditState(
      status: CreditStatus.success,
      totalCredits: _currentCredits,
      creditsAdded: creditsAdded,
    ));

    print('💰 Credits updated: +$creditsAdded, Total: $_currentCredits');
  }

  void _emitState(CreditState state) {
    _stateController.add(state);
  }

  @override
  void dispose() {
    _stateController.close();
  }

  // Factory method
  static CreditViewModel create() {
    final apiService = HttpApiService();
    final remoteDataSource = CreditRemoteDataSourceImpl(apiService: apiService);
    final repository =
        CreditSummaryRepositoryImpl(remoteDataSource: remoteDataSource);
    final useCase = GetCreditSummaryUseCase(repository: repository);

    return CreditViewModel(
      getCreditSummaryUseCase: useCase,
    );
  }
}
