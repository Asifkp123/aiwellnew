abstract class ApiResponse<T> {
  T? get data;
  String? get errorMessage;
  bool get isSuccess;

  ApiResponse<T> copyWith({
    T? data,
    String? errorMessage,
    bool? isSuccess,
  });
}

class ApiResponseImpl<T> implements ApiResponse<T> {
  @override
  final T? data;
  @override
  final String? errorMessage;
  @override
  final bool isSuccess;

  ApiResponseImpl({
    this.data,
    this.errorMessage,
    required this.isSuccess,
  });

  factory ApiResponseImpl.success(T data) => ApiResponseImpl<T>(
    data: data,
    isSuccess: true,
  );

  factory ApiResponseImpl.error(String errorMessage) => ApiResponseImpl<T>(
    errorMessage: errorMessage,
    isSuccess: false,
  );

  @override
  ApiResponseImpl<T> copyWith({
    T? data,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ApiResponseImpl<T>(
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  String toString() {
    return 'ApiResponseImpl(data: $data, errorMessage: $errorMessage, isSuccess: $isSuccess)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ApiResponseImpl &&
              runtimeType == other.runtimeType &&
              data == other.data &&
              errorMessage == other.errorMessage &&
              isSuccess == other.isSuccess;

  @override
  int get hashCode => data.hashCode ^ errorMessage.hashCode ^ isSuccess.hashCode;
}