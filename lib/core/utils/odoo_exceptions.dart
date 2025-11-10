class OdooException implements Exception {
  final String message;
  final int? code;
  final dynamic data;

  OdooException(this.message, {this.code, this.data});

  @override
  String toString() => 'OdooException: $message (code: $code)';
}

class OdooSessionExpiredException extends OdooException {
  OdooSessionExpiredException(String message) : super(message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException(this.message);

  @override
  String toString() => 'UnexpectedException: $message';
}
