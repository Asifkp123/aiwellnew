# Clean Architecture Implementation Guide

## Architecture Overview
This document provides a complete implementation of Clean Architecture based on the data flow diagram, with code examples for each layer.

## Layer Structure

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           ARCHITECTURE LAYERS                                 │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                                 VIEW LAYER                                    │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐          │
│  │   User Input    │    │   UI State      │    │   Navigation    │          │
│  │   (Button Tap)  │    │   (Loading)     │    │   (Route Push)  │          │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘          │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                            VIEW MODEL LAYER                                   │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐          │
│  │   UI Validation │    │   State Stream  │    │   UseCase Call  │          │
│  │   (Input Check) │    │   (Loading/Data)│    │   (execute())   │          │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘          │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              USECASE LAYER                                    │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐          │
│  │ Business Logic  │    │   Validation    │    │ Repository Call │          │
│  │   (Rules)       │    │   (Domain)      │    │   (execute())   │          │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘          │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                             REPOSITORY LAYER                                  │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐          │
│  │ Data Source     │    │   Model         │    │ API Call        │          │
│  │   Selection     │    │   Mapping       │    │   Preparation   │          │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘          │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                            DATA SOURCE LAYER                                  │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐          │
│  │   HTTP Client   │    │   Response      │    │   External      │          │
│  │   (API Call)    │    │   Handling      │    │   API           │          │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘          │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Implementation Code Examples

### 1. VIEW LAYER (Presentation)

```dart
// lib/features/pal_creation/presentation/screens/create_pal_screen.dart
import 'package:flutter/material.dart';
import '../view_models/create_pal_view_model.dart';

class CreatePalScreen extends StatefulWidget {
  @override
  _CreatePalScreenState createState() => _CreatePalScreenState();
}

class _CreatePalScreenState extends State<CreatePalScreen> {
  final CreatePalViewModel _viewModel = CreatePalViewModel();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Pal')),
      body: StreamBuilder<CreatePalState>(
        stream: _viewModel.stateStream,
        builder: (context, snapshot) {
          final state = snapshot.data ?? CreatePalState.initial();
          
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // User Input
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Pal Name',
                    errorText: state.nameError,
                  ),
                ),
                
                SizedBox(height: 16),
                
                // UI State - Loading
                if (state.isLoading)
                  CircularProgressIndicator(),
                else
                  ElevatedButton(
                    onPressed: () => _viewModel.createPal(_nameController.text),
                    child: Text('Create Pal'),
                  ),
                
                // Navigation - Success
                if (state.isSuccess)
                  Text('Pal created successfully!', 
                       style: TextStyle(color: Colors.green)),
                
                // Error Display
                if (state.error != null)
                  Text(state.error!, 
                       style: TextStyle(color: Colors.red)),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### 2. VIEW MODEL LAYER (Presentation Logic)

```dart
// lib/features/pal_creation/presentation/view_models/create_pal_view_model.dart
import 'dart:async';
import '../../../domain/usecases/create_pal_use_case.dart';
import '../../../domain/entities/pal.dart';

enum CreatePalStatus { initial, loading, success, error }

class CreatePalState {
  final CreatePalStatus status;
  final bool isLoading;
  final String? error;
  final String? nameError;
  final Pal? createdPal;

  CreatePalState({
    this.status = CreatePalStatus.initial,
    this.isLoading = false,
    this.error,
    this.nameError,
    this.createdPal,
  });

  CreatePalState copyWith({
    CreatePalStatus? status,
    bool? isLoading,
    String? error,
    String? nameError,
    Pal? createdPal,
  }) {
    return CreatePalState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      nameError: nameError,
      createdPal: createdPal ?? this.createdPal,
    );
  }

  factory CreatePalState.initial() => CreatePalState();
}

class CreatePalViewModel {
  final CreatePalUseCase _createPalUseCase;
  final StreamController<CreatePalState> _stateController = 
      StreamController<CreatePalState>.broadcast();

  CreatePalViewModel({CreatePalUseCase? createPalUseCase})
      : _createPalUseCase = createPalUseCase ?? CreatePalUseCase();

  Stream<CreatePalState> get stateStream => _stateController.stream;

  // UI Validation
  String? _validateInput(String name) {
    if (name.isEmpty) return 'Name is required';
    if (name.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  // UseCase Call
  Future<void> createPal(String name) async {
    // UI Validation
    final nameError = _validateInput(name);
    if (nameError != null) {
      _stateController.add(CreatePalState(
        status: CreatePalStatus.error,
        nameError: nameError,
      ));
      return;
    }

    // Set Loading State
    _stateController.add(CreatePalState(
      status: CreatePalStatus.loading,
      isLoading: true,
    ));

    try {
      // Call UseCase
      final result = await _createPalUseCase.execute(CreatePalParams(name: name));
      
      result.fold(
        (failure) {
          // Error Handling
          _stateController.add(CreatePalState(
            status: CreatePalStatus.error,
            error: failure.message,
          ));
        },
        (pal) {
          // Success State
          _stateController.add(CreatePalState(
            status: CreatePalStatus.success,
            createdPal: pal,
          ));
        },
      );
    } catch (e) {
      _stateController.add(CreatePalState(
        status: CreatePalStatus.error,
        error: e.toString(),
      ));
    }
  }

  void dispose() {
    _stateController.close();
  }
}
```

### 3. USECASE LAYER (Domain Logic)

```dart
// lib/features/pal_creation/domain/usecases/create_pal_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../entities/pal.dart';
import '../repositories/pal_repository.dart';

class CreatePalParams {
  final String name;
  
  CreatePalParams({required this.name});
}

class CreatePalUseCase {
  final PalRepository _palRepository;

  CreatePalUseCase({PalRepository? palRepository})
      : _palRepository = palRepository ?? PalRepositoryImpl();

  // Business Logic
  Future<Either<Failure, Pal>> execute(CreatePalParams params) async {
    // Domain Validation
    if (!_isValidName(params.name)) {
      return Left(Failure('Invalid name format'));
    }

    // Business Rules
    if (_isReservedName(params.name)) {
      return Left(Failure('This name is reserved'));
    }

    // Repository Call
    final result = await _palRepository.createPal(
      CreatePalRequest(name: params.name),
    );

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(Pal.fromResponse(response)),
    );
  }

  // Business Logic Validation
  bool _isValidName(String name) {
    return name.isNotEmpty && name.length >= 2 && name.length <= 50;
  }

  // Business Rules
  bool _isReservedName(String name) {
    final reservedNames = ['admin', 'system', 'test'];
    return reservedNames.contains(name.toLowerCase());
  }
}
```

### 4. REPOSITORY LAYER (Data Abstraction)

```dart
// lib/features/pal_creation/domain/repositories/pal_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../data/models/api/create_pal_request.dart';
import '../../data/models/api/create_pal_response.dart';

abstract class PalRepository {
  Future<Either<Failure, CreatePalResponse>> createPal(CreatePalRequest request);
}

class PalRepositoryImpl implements PalRepository {
  final PalRemoteDataSource _palRemoteDataSource;

  PalRepositoryImpl({required PalRemoteDataSource palRemoteDataSource})
      : _palRemoteDataSource = palRemoteDataSource;

  @override
  Future<Either<Failure, CreatePalResponse>> createPal(
      CreatePalRequest request) async {
    try {
      // Data Source Selection & API Call
      return await _palRemoteDataSource.createPal(request);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
```

### 5. DATA SOURCE LAYER (Data Implementation)

```dart
// lib/features/pal_creation/data/datasources/remote/pal_remote_datasource.dart
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/config/api_config.dart';
import '../../../../../core/network/error/failure.dart';
import '../../models/api/create_pal_request.dart';
import '../../models/api/create_pal_response.dart';
import '../../../../auth/data/datasources/local/auth_local_datasource.dart';

abstract class PalRemoteDataSource {
  Future<Either<Failure, CreatePalResponse>> createPal(CreatePalRequest request);
}

class PalRemoteDataSourceImpl implements PalRemoteDataSource {
  final AuthLocalDataSourceBase _authLocalDataSource;

  PalRemoteDataSourceImpl({required AuthLocalDataSourceBase authLocalDataSource})
      : _authLocalDataSource = authLocalDataSource;

  @override
  Future<Either<Failure, CreatePalResponse>> createPal(
      CreatePalRequest request) async {
    try {
      // HTTP Client Setup
      final accessToken = await _authLocalDataSource.getAccessToken();
      if (accessToken == null) {
        return Left(Failure('Authentication token is missing'));
      }

      // API Call
      final response = await http.post(
        Uri.parse(ApiConfig.patientCreationEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(request.toJson()),
      );

      // Response Handling
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return Right(CreatePalResponse.fromJson(responseBody));
      } else {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = responseBody['detail'] ?? 'Unknown error';
        return Left(Failure(errorMessage));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
```

### 6. ENTITIES & MODELS

```dart
// lib/features/pal_creation/domain/entities/pal.dart
class Pal {
  final String id;
  final String name;
  final DateTime createdAt;

  Pal({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Pal.fromResponse(CreatePalResponse response) {
    return Pal(
      id: response.id,
      name: response.name,
      createdAt: DateTime.parse(response.createdAt),
    );
  }
}

// lib/features/pal_creation/data/models/api/create_pal_request.dart
class CreatePalRequest {
  final String name;

  CreatePalRequest({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

// lib/features/pal_creation/data/models/api/create_pal_response.dart
class CreatePalResponse {
  final String id;
  final String name;
  final String createdAt;

  CreatePalResponse({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory CreatePalResponse.fromJson(Map<String, dynamic> json) {
    return CreatePalResponse(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
    );
  }
}
```

### 7. DEPENDENCY INJECTION

```dart
// lib/features/pal_creation/di/pal_injection.dart
import 'package:get_it/get_it.dart';
import '../data/datasources/remote/pal_remote_datasource.dart';
import '../data/repositories/pal_repository.dart';
import '../domain/usecases/create_pal_use_case.dart';
import '../presentation/view_models/create_pal_view_model.dart';

class PalInjection {
  static void init() {
    // Data Sources
    GetIt.instance.registerLazySingleton<PalRemoteDataSource>(
      () => PalRemoteDataSourceImpl(
        authLocalDataSource: GetIt.instance<AuthLocalDataSourceBase>(),
      ),
    );

    // Repositories
    GetIt.instance.registerLazySingleton<PalRepository>(
      () => PalRepositoryImpl(
        palRemoteDataSource: GetIt.instance<PalRemoteDataSource>(),
      ),
    );

    // Use Cases
    GetIt.instance.registerLazySingleton<CreatePalUseCase>(
      () => CreatePalUseCase(
        palRepository: GetIt.instance<PalRepository>(),
      ),
    );

    // View Models
    GetIt.instance.registerFactory<CreatePalViewModel>(
      () => CreatePalViewModel(
        createPalUseCase: GetIt.instance<CreatePalUseCase>(),
      ),
    );
  }
}
```

## Data Flow Implementation

### Request Flow (Downward)
1. **View**: User taps button → calls ViewModel method
2. **ViewModel**: Validates input → calls UseCase
3. **UseCase**: Applies business logic → calls Repository
4. **Repository**: Maps data → calls DataSource
5. **DataSource**: Makes HTTP request → calls External API

### Response Flow (Upward)
1. **External API**: Returns JSON response
2. **DataSource**: Handles response → returns Either<Failure, Response>
3. **Repository**: Maps response → returns Either<Failure, Entity>
4. **UseCase**: Transforms data → returns Either<Failure, Entity>
5. **ViewModel**: Updates state → notifies View via Stream
6. **View**: Displays result → shows success/error

### Error Flow
1. **API Error**: 4xx/5xx response
2. **DataSource**: Wraps in Failure
3. **Repository**: Passes through Failure
4. **UseCase**: Passes through Failure
5. **ViewModel**: Updates error state
6. **View**: Displays error message

## Key Principles Implemented

1. **Dependency Rule**: Dependencies point inward
2. **Single Responsibility**: Each layer has one purpose
3. **Abstraction**: Inner layers don't know about outer layers
4. **Stream-Based Communication**: Reactive UI updates
5. **Error Handling**: Consistent error propagation
6. **Testability**: Each layer can be tested independently

## Usage Example

```dart
// In your main.dart or app initialization
void main() {
  PalInjection.init();
  runApp(MyApp());
}

// In your screen
class CreatePalScreen extends StatefulWidget {
  @override
  _CreatePalScreenState createState() => _CreatePalScreenState();
}

class _CreatePalScreenState extends State<CreatePalScreen> {
  late final CreatePalViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.instance<CreatePalViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CreatePalState>(
      stream: _viewModel.stateStream,
      builder: (context, snapshot) {
        // Build UI based on state
      },
    );
  }
}
```

This implementation provides a complete, scalable Clean Architecture structure that follows the data flow diagram and can be used as a template for all features in your application. 