class Success {
  final int code;
  final Object response;
  Success({
    required this.code,
    required this.response,
  });
}

class Failure {
  final int code;
  final String response;
  Failure({
    required this.code,
    required this.response,
  });
}
