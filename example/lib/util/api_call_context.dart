import 'dart:async';

class ApiCallContext {
  static const String apiCallZoneKey = 'api_call_zone';
  static const String apiCallResultCollectorZoneKey =
      'api_call_result_collector';
}

class ApiResultCollector {
  String? message;
  Object? error;
  bool hasError = false;

  void record({required bool isError, required String message, Object? error}) {
    this.message = message;
    if (!isError) {
      return;
    }

    hasError = true;
    this.error = error ?? Exception(message);
  }
}

void recordApiCallResult({
  required bool isError,
  required String message,
  Object? error,
}) {
  if (Zone.current[ApiCallContext.apiCallZoneKey] != true) {
    return;
  }

  final ApiResultCollector? collector =
      Zone.current[ApiCallContext.apiCallResultCollectorZoneKey];
  collector?.record(isError: isError, message: message, error: error);
}
