abstract class BaseException implements Exception{
  final String debugMessage;
  final String userMessage;

  BaseException(this.debugMessage, this.userMessage);
}

class BadStateException extends BaseException{
  BadStateException(String debugMessage, String userMessage) : super(debugMessage, userMessage);
}

class NetworkException extends BaseException{
  NetworkException({
    String message = 'Failed to connect',
  }) : super('Network error', message);
}

abstract class APIError implements BaseException{
  final int code;
  final String uri;
  @override
  final String debugMessage;
  @override
  final String userMessage;

  APIError(this.code, this.uri, this.debugMessage, this.userMessage);
}

class SessionExpired extends APIError{
  SessionExpired(Uri url, String message) : super(401, url.toString(), 'Session Expired', message);
}

class BadRequest extends APIError{
  BadRequest(Uri url, String message) : super(400, url.toString(), 'Bad request', message);
}

class ServerError extends APIError{
  ServerError(Uri url, String message) : super(500, url.toString(), 'Server error', message);
}

class NotFound extends APIError{
  NotFound(Uri url, String message) : super(404, url.toString(), 'Not found', message);
}

class UnknownError extends APIError{
  UnknownError(Uri url, String message) : super(520, url.toString(), 'Unknown error', message);
}
