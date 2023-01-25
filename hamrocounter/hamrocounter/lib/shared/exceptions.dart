
abstract class BaseException implements Exception {

  final String debugMessage;
  final String userMessage;

  BaseException(this.debugMessage, this.userMessage);
}

class BadStateException extends BaseException {

  BadStateException(super.debugMessage, super.userMessage);
}

class NetworkException extends BaseException {

  NetworkException({
    String message = 'Failed to connect',
  }) : super('Network error', message);
}

abstract class APIError implements BaseException {

  final int code;
  final Uri uri;
  @override
  final String debugMessage;
  @override
  final String userMessage;

  APIError(this.code, this.uri, this.debugMessage, this.userMessage);

}

class SessionExpired extends APIError {

  SessionExpired(Uri url, String message) : super(401, url, 'Session Expired', message);
}

class BadRequest extends APIError {

  BadRequest(Uri url, String message) : super(400, url, 'Bad Request', message);
}

class ServerError extends APIError {

  ServerError(Uri url, String message) : super(500, url, 'Server Error',message);
}

class NotFound extends APIError {

  NotFound(Uri url, String message) : super(404, url, 'Not Found', message);
}

class UnknownError extends APIError {

  UnknownError(Uri url, String message) : super(520, url, 'Unknown API Error', message);
}
