abstract class ApiResponse<T> {
  T? get data;
  String? get errorMessage;
  bool get isSuccess;
  Map<String, String>? get headers;

  ApiResponse<T> copyWith({
    T? data,
    String? errorMessage,
    bool? isSuccess,
    Map<String, String>? headers,
  });
}

class ApiResponseImpl<T> implements ApiResponse<T> {
  @override
  final T? data;
  @override
  final String? errorMessage;
  @override
  final bool isSuccess;
  @override
  final Map<String, String>? headers;

  ApiResponseImpl({
    this.data,
    this.errorMessage,
    required this.isSuccess,
    this.headers,
  });

  factory ApiResponseImpl.success(T data, {Map<String, String>? headers}) => ApiResponseImpl<T>(
    data: data,
    isSuccess: true,
    headers: headers,
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
    Map<String, String>? headers,
  }) {
    return ApiResponseImpl<T>(
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      headers: headers ?? this.headers,
    );
  }

  @override
  String toString() {
    return 'ApiResponseImpl(data: $data, errorMessage: $errorMessage, isSuccess: $isSuccess, headers: $headers)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ApiResponseImpl &&
              runtimeType == other.runtimeType &&
              data == other.data &&
              errorMessage == other.errorMessage &&
              isSuccess == other.isSuccess &&
              headers == other.headers;

  @override
  int get hashCode => data.hashCode ^ errorMessage.hashCode ^ isSuccess.hashCode ^ headers.hashCode;
}