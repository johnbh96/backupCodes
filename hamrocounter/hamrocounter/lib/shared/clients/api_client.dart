import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:yatru_sewa/shared/models/login_form_data.dart';
import 'package:yatru_sewa/shared/shared.dart';
import 'package:yatru_sewa/shared/models/serialization.dart';

typedef CredentialSetter = Future Function(String, String);
typedef CredentialDeleter = AsyncCallback;
typedef AccessTokenGetter = Future<String?> Function();
typedef RefreshTokenGetter = Future<String?> Function();
typedef AccessTokenSetter = StringAsyncCallback;

enum HttpMethods { get, post, put, delete }

class ApiClient {

  final String host;
  final String scheme;
  final int port;
  final AccessTokenGetter getAccessToken;
  final RefreshTokenGetter getRefreshToken;
  final AccessTokenSetter setAccessToken;

  ApiClient({
    required this.host,
    required String? initialAccessToken,
    required this.getAccessToken,
    required this.getRefreshToken,
    required this.setAccessToken,
    this.scheme = kDebugMode ? 'http' : 'https',
    this.port = kDebugMode ? 8000 : 80,
  }) : _accessToken = initialAccessToken, _accessTokenCompleter = Completer() {
    _accessTokenCompleter.complete(initialAccessToken ?? '');
  }

  late String? _accessToken;
  late Completer<String> _accessTokenCompleter;

  Future<T> request<T, D>({
    required String path,
    required HttpMethods method,
    D? data,
    bool isProtected = true,
    Map<String, String> additionalHeaders = const {},
    VoidCallback? onSessionExpired,
    bool shouldRefreshAccessToken = true,
  }) async {
    var uri = Uri(
      path: path,
      port: port,
      scheme: scheme,
      host: host,
    );
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    }..addAll(additionalHeaders);

    if (isProtected) {
      headers.addAll({'Authorization': 'Bearer $_accessToken'});
    }

    late http.Response response;

    //try catch here!!!!!!!
    try {
      switch(method) {
        case HttpMethods.get:
          response = await http.get(uri, headers: headers);
          break;
        case HttpMethods.post:
          final body = serializers.serializeWith(serializers.serializerForType(D)!, data);
          response = await http.post(uri, headers: headers, body: jsonEncode(body));
          break;
        case HttpMethods.put:
          final body = serializers.serializeWith(serializers.serializerForType(D)!, data);
          response = await http.put(uri, headers: headers, body: jsonEncode(body));
          break;
        case HttpMethods.delete:
          response = await http.delete(uri, headers: headers);
          break;
      }
    } catch (e) {
      throw NetworkException();
    }

    if (response.statusCode == 200) {
      final result = serializers.deserializeWith(
        serializers.serializerForType(T)!, json.decode(response.body));
      return result;
    }

    //when access token is invalid, get new accessToken using refreshToken
    //and store it in KeyChainRepository
    if (response.statusCode == 401 && shouldRefreshAccessToken) {
      final errorResponse = serializers.deserializeWith<TokenExpiredError>(
        TokenExpiredError.serializer, json.decode(response.body));

      if ((errorResponse?.code ?? '') == 'token_not_valid') {

        // access token expired
        if (errorResponse?.messages.where((m) => m.tokenType == 'access').isNotEmpty ?? false) {

          await _refreshAccessToken(host);
          return request(
            method: method,
            path: path,
            data: data,
            isProtected: isProtected,
            additionalHeaders: additionalHeaders,
            shouldRefreshAccessToken: false,
          );
        }
      }

      throw SessionExpired(uri, 'Logged out');
    } else if (response.statusCode == 400) {
      // ignore: todo
      // TODO: deserialize errors
      throw BadRequest(uri, 'Invalid request');
    } else if (response.statusCode == 500) {
      throw ServerError(uri, 'error in the server,[500]');
    } else if (response.statusCode == 404) {
      throw NotFound(uri, 'content couldnot be found,[404]');
    }

    throw UnknownError(uri, 'Something went wrong: ${response.statusCode}');
  }

  Future<T> get<T>({
    required String path,
    bool isProtected = true,
    Map<String, String> additionalHeaders = const {},
    VoidCallback? onSessionExpired,
    bool shouldRefreshAccessToken = true,
  }) {
    return request(
      path: path,
      method: HttpMethods.get,
      isProtected: isProtected,
      additionalHeaders: additionalHeaders,
      onSessionExpired: onSessionExpired,
      shouldRefreshAccessToken: shouldRefreshAccessToken,
    );
  }


Future<T> post<T, D>({
    required String path,
    D? data,
    bool isProtected = true,
    Map<String, String> additionalHeaders = const {},
    VoidCallback? onSessionExpired,
    bool shouldRefreshAccessToken = true,
  }) async {
    return request(
      path: path,
      method: HttpMethods.post,
      data: data,
      isProtected: isProtected,
      additionalHeaders: additionalHeaders,
      onSessionExpired: onSessionExpired,
      shouldRefreshAccessToken: shouldRefreshAccessToken,
    );
  }

  Future<T> put<T, D>({
    required String path,
    D? data,
    bool isProtected = true,
    Map<String, String> additionalHeaders = const {},
    VoidCallback? onSessionExpired,
    bool shouldRefreshAccessToken = true,
  }) async {
    return request(
      path: path,
      method: HttpMethods.put,
      data: data,
      isProtected: isProtected,
      additionalHeaders: additionalHeaders,
      onSessionExpired: onSessionExpired,
      shouldRefreshAccessToken: shouldRefreshAccessToken,
    );
  }

  Future<T> delete<T>({
    required String path,
    bool isProtected = true,
    Map<String, String> additionalHeaders = const {},
    VoidCallback? onSessionExpired,
    bool shouldRefreshAccessToken = true,
  }) async {
    return request(
      path: path,
      method: HttpMethods.delete,
      isProtected: isProtected,
      additionalHeaders: additionalHeaders,
      onSessionExpired: onSessionExpired,
      shouldRefreshAccessToken: shouldRefreshAccessToken,
    );
  }

  Future<LoginSuccessData> login(LoginFormData data) async {

    return await request<LoginSuccessData, LoginFormData>(
      path: 'auth/login/',
      method: HttpMethods.post,
      data: data,
      isProtected: false,
      shouldRefreshAccessToken: false,
    );
  }

  Future _refreshAccessToken(String host) async {

    if (!_accessTokenCompleter.isCompleted) {
      return _accessTokenCompleter.future;
    }
    
    try {

      _accessTokenCompleter = Completer();

      final refreshToken = await getRefreshToken();
      final body = serializers.serializeWith(
        RefreshToken.serializer,
        RefreshToken((b) => b..refreshToken = refreshToken),
      );

      final refreshTokenResponse = await http.post(
        Uri(
          path: 'auth/token/refresh/',
          port: port,
          scheme: scheme,
          host: host,
        ),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'grant_type': 'token_refresh',
        }
      );

      if (refreshTokenResponse.statusCode != 200) {
        // TODO: complete with API Exception
        _accessTokenCompleter.completeError(Exception('Request Error'));
        return;
      }

      final accessToken = serializers.deserializeWith(
        AccessToken.serializer,
        refreshTokenResponse.body,
      );

      if (accessToken == null) {
        // TODO: use debug exception type
        _accessTokenCompleter.completeError(Exception('Failed to deserialize access token'));
        return;
      }

      _accessToken = accessToken.access;
      await setAccessToken(accessToken.access);
      _accessTokenCompleter.complete(accessToken.access);
      return;
    } catch (error) {
      _accessTokenCompleter.completeError(error);
      return;
    }
  }
}
