# Domain-Specific Validation Examples

## What is Domain-Specific Validation?

Domain-specific validation refers to **business rules and validation logic** that belong to the **domain layer (Use Cases)** rather than UI validation. These are rules that are part of your business logic and should be consistent across all applications that use your domain.

## Real Examples from Your Project

### 1. **RequestOtpUseCase** - Domain Validation

```dart
class RequestOtpUseCase extends RequestOtpUseCaseBase {
  final AuthRepository repository;

  RequestOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, OtpRequestSuccess>> execute(
      {String? email, String? phoneNumber}) async {
    
    // 🔥 DOMAIN VALIDATION: Business rules for OTP requests
    if (email == null && phoneNumber == null) {
      return Left(Failure('Either email or phone number is required'));
    }

    if (email != null && email.trim().isEmpty) {
      return Left(Failure('Email cannot be empty'));
    }

    if (phoneNumber != null && phoneNumber.trim().isEmpty) {
      return Left(Failure('Phone number cannot be empty'));
    }

    // 🔥 DOMAIN VALIDATION: Email format validation (business rule)
    if (email != null) {
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(email.trim())) {
        return Left(Failure('Invalid email format'));
      }
    }

    // 🔥 DOMAIN VALIDATION: Phone number format validation (business rule)
    if (phoneNumber != null) {
      final phoneRegex = RegExp(r'^\+?[1-9]\d{9,14}$');
      if (!phoneRegex.hasMatch(phoneNumber.trim())) {
        return Left(Failure('Invalid phone number format'));
      }
    }

    // Execute the repository call
    return await repository.requestOtp(
      email: email?.trim(),
      phoneNumber: phoneNumber?.trim(),
    );
  }
}
```

### 2. **CreatePalUseCase** - Domain Validation Example

```dart
class CreatePalUseCase implements CreatePalUseCaseBase {
  final PalRepository palRepository;

  CreatePalUseCase({required this.palRepository});

  @override
  Future<Either<Failure, CreatePalResponse>> execute(CreatePalRequest request) async {
    
    // 🔥 DOMAIN VALIDATION: Business rules for PAL creation
    if (request.firstName.trim().isEmpty || request.lastName.trim().isEmpty) {
      return Left(Failure('First name and last name are required'));
    }

    if (request.firstName.length < 2 || request.lastName.length < 2) {
      return Left(Failure('Names must be at least 2 characters long'));
    }

    // 🔥 DOMAIN VALIDATION: Age validation (business rule)
    try {
      final dob = DateTime.parse(request.dob);
      final age = DateTime.now().year - dob.year;
      if (age < 18 || age > 120) {
        return Left(Failure('Age must be between 18 and 120 years'));
      }
    } catch (e) {
      return Left(Failure('Invalid date of birth format'));
    }

    // 🔥 DOMAIN VALIDATION: Gender validation (business rule)
    final validGenders = ['male', 'female', 'other'];
    if (!validGenders.contains(request.gender.toLowerCase())) {
      return Left(Failure('Gender must be male, female, or other'));
    }

    // 🔥 DOMAIN VALIDATION: Medical condition validation (business rule)
    if (request.isBedridden == true && request.canWalk == true) {
      return Left(Failure('A bedridden person cannot be marked as able to walk'));
    }

    if (request.hasDementia == true && request.dominantEmotion == null) {
      return Left(Failure('Dominant emotion is required for dementia patients'));
    }

    return await palRepository.createPal(request);
  }
}
```

### 3. **SubmitProfileUseCase** - Domain Validation Example

```dart
class SubmitProfileUseCase implements SubmitProfileUseCaseBase {
  final AuthRepository authRepository;

  SubmitProfileUseCase({required this.authRepository});

  @override
  Future<Either<Failure, SubmitProfileResponse>> execute({
    required String firstName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String dominantEmotion,
    required String sleepQuality,
    required String physicalActivity,
  }) async {
    
    // 🔥 DOMAIN VALIDATION: Name validation (business rule)
    if (firstName.trim().length < 2 || lastName.trim().length < 2) {
      return Left(Failure('Names must be at least 2 characters long'));
    }

    if (firstName.trim().length > 50 || lastName.trim().length > 50) {
      return Left(Failure('Names cannot exceed 50 characters'));
    }

    // 🔥 DOMAIN VALIDATION: Age validation (business rule)
    try {
      final dob = DateTime.parse(dateOfBirth);
      final age = DateTime.now().year - dob.year;
      if (age < 13 || age > 120) {
        return Left(Failure('Age must be between 13 and 120 years'));
      }
    } catch (e) {
      return Left(Failure('Invalid date of birth format'));
    }

    // 🔥 DOMAIN VALIDATION: Emotion validation (business rule)
    final validEmotions = ['happy', 'sad', 'angry', 'anxious', 'calm', 'tired', 'confused', 'excited', 'scared', 'neutral'];
    if (!validEmotions.contains(dominantEmotion.toLowerCase())) {
      return Left(Failure('Invalid dominant emotion selected'));
    }

    // 🔥 DOMAIN VALIDATION: Sleep quality validation (business rule)
    final validSleepQualities = ['excellent', 'good', 'fair', 'poor'];
    if (!validSleepQualities.contains(sleepQuality.toLowerCase())) {
      return Left(Failure('Invalid sleep quality selected'));
    }

    // 🔥 DOMAIN VALIDATION: Physical activity validation (business rule)
    final validActivities = ['low', 'moderate', 'high', 'none'];
    if (!validActivities.contains(physicalActivity.toLowerCase())) {
      return Left(Failure('Invalid physical activity level selected'));
    }

    final result = await authRepository.submitProfile(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      dominantEmotion: dominantEmotion,
      sleepQuality: sleepQuality,
      physicalActivity: physicalActivity,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response),
    );
  }
}
```

## Additional Real-World Examples

### 4. **Banking Domain** - Account Transfer Validation

```dart
class TransferMoneyUseCase {
  final AccountRepository accountRepository;

  TransferMoneyUseCase({required this.accountRepository});

  Future<Either<Failure, TransferResponse>> execute(TransferRequest request) async {
    
    // 🔥 DOMAIN VALIDATION: Business rules for money transfers
    
    // Minimum transfer amount
    if (request.amount < 1.0) {
      return Left(Failure('Minimum transfer amount is $1.00'));
    }

    // Maximum transfer amount
    if (request.amount > 10000.0) {
      return Left(Failure('Maximum transfer amount is $10,000.00'));
    }

    // Cannot transfer to same account
    if (request.fromAccountId == request.toAccountId) {
      return Left(Failure('Cannot transfer to the same account'));
    }

    // Check account balance
    final account = await accountRepository.getAccount(request.fromAccountId);
    if (account.balance < request.amount) {
      return Left(Failure('Insufficient funds'));
    }

    // Business hours validation
    final now = DateTime.now();
    if (now.hour < 9 || now.hour > 17) {
      return Left(Failure('Transfers are only allowed during business hours (9 AM - 5 PM)'));
    }

    return await accountRepository.transferMoney(request);
  }
}
```

### 5. **E-commerce Domain** - Order Validation

```dart
class CreateOrderUseCase {
  final OrderRepository orderRepository;
  final InventoryRepository inventoryRepository;

  CreateOrderUseCase({
    required this.orderRepository,
    required this.inventoryRepository,
  });

  Future<Either<Failure, OrderResponse>> execute(CreateOrderRequest request) async {
    
    // 🔥 DOMAIN VALIDATION: Business rules for order creation
    
    // Minimum order amount
    if (request.totalAmount < 10.0) {
      return Left(Failure('Minimum order amount is $10.00'));
    }

    // Check inventory for each item
    for (final item in request.items) {
      final inventory = await inventoryRepository.getInventory(item.productId);
      if (inventory.quantity < item.quantity) {
        return Left(Failure('Insufficient inventory for product ${item.productId}'));
      }
    }

    // Shipping address validation
    if (request.shippingAddress.country == 'US' && request.totalAmount > 1000.0) {
      return Left(Failure('Orders over $1000 require additional verification'));
    }

    // Payment method validation
    if (request.paymentMethod == 'credit_card' && request.totalAmount > 500.0) {
      return Left(Failure('Credit card payments limited to $500. Please use bank transfer'));
    }

    return await orderRepository.createOrder(request);
  }
}
```

## Key Differences: UI vs Domain Validation

### UI Validation (ViewModel Layer)
```dart
// In ViewModel - UI-specific validation
bool validateEmail(String email) {
  if (email.isEmpty) {
    _errorMessage = 'Please enter an email';
    return false;
  }
  return true;
}
```

### Domain Validation (Use Case Layer)
```dart
// In UseCase - Business rule validation
if (email != null) {
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (!emailRegex.hasMatch(email.trim())) {
    return Left(Failure('Invalid email format')); // Business rule
  }
}
```

## Why Domain Validation Matters

1. **Business Rules**: Enforces actual business logic, not just UI requirements
2. **Consistency**: Same validation across all applications (web, mobile, API)
3. **Security**: Prevents invalid data from reaching the database
4. **Maintainability**: Business rules are centralized in domain layer
5. **Testability**: Easy to unit test business logic independently

## Best Practices

1. **Keep UI validation simple** (empty checks, basic format)
2. **Put complex business rules in Use Cases**
3. **Use descriptive error messages** for business rules
4. **Validate early** in the domain layer
5. **Make validation rules configurable** when possible 