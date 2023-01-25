import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../models/session_tokens/session_tokens.dart';
import '../../models/token_expired_error/token_expired_error.dart';
import '../enums/enum_collections.dart';
import '../exceptions/exception.dart';
import '../serializer/serialization.dart';
import 'components/types.dart';

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
  }) : _accessToken = initialAccessToken, _accessTokenCompleter = Completer<String>(){
    _accessTokenCompleter.complete(initialAccessToken ?? '');
  }

  late final String? _accessToken;
  late final Completer<String> _accessTokenCompleter;
  
  Future<T> apiRequest<T, D>({
    required String path,
    required HttpMethods httpMethods,
    D? data,
    bool isProtected = true,
    Map<String, String> additionalHeaders = const <String, String>{},
    VoidCallback? onSessionExpired,
    bool shouldRefreshAccessToken = true,
  }) async {
    late http.Response response;

    final Uri uri = Uri(
      path: path,
      scheme: scheme,
      port: port,
      host: host,
    );

    final Map<String, String> headers = <String, String>{
      'Content-Type' : 'application/json'
    }..addAll(additionalHeaders);

    if (isProtected){
      headers.addAll(<String, String>{
        'Authorization' : 'Bearer $_accessToken'}
      );
    }

    try{
      final Object? body = serializers.serializeWith<dynamic>(
        serializers.serializerForType(D)!,
        data
      );

      switch(httpMethods){
        case HttpMethods.get:
          response = await http.get(uri, headers: headers);
          break;
        case HttpMethods.post:
          response = await http.post(uri, headers: headers, body: jsonEncode(body));
          break;
        case HttpMethods.put:
          response = await http.put(uri, headers: headers, body: jsonEncode(body));
          break;
        case HttpMethods.delete:
          response = await http.delete(uri, headers: headers);
          break;
      }
    }catch(e){
      throw NetworkException();
    }

    if (response.statusCode == 200){
      final Object result = await serializers.deserializeWith<dynamic>(
        serializers.serializerForType(T)!,
        json.decode(response.body)
      );
      return result as Future<T>;
    }

    if (response.statusCode == 401 && shouldRefreshAccessToken){
      final TokenExpiredError? errorResponse = serializers.deserializeWith<TokenExpiredError>(
        TokenExpiredError.serializer,
        json.decode(response.body)
      );

      if ((errorResponse?.code ?? '') == 'token_not_valid'){

        if (errorResponse?.message.where((TokenExpiredErrorMessage m) => m.tokenType == 'access').isNotEmpty ?? false){
          await _refreshAccessToken(host);
          return apiRequest(
            path: path, 
            httpMethods: httpMethods,
            data: data,
            isProtected: isProtected,
            additionalHeaders: additionalHeaders,
            onSessionExpired: onSessionExpired,
          );
        }
      }

      throw SessionExpired(uri, 'Logged out');
    }else if (response.statusCode == 400){
      throw BadRequest(uri, 'Invalid Request');
    }else if (response.statusCode == 500){
      throw ServerError(uri, 'Error in the server, [500]');
    }else if (response.statusCode == 404){
      throw NotFound(uri, 'Content could not be found, [404]');
    }
    throw UnknownError(uri, 'Something went wrong: ${response.statusCode}');
  }

  Future<T> get<T>({ 
    required String path,
    bool isProtected = true,
    Map<String, String> additionalHeaders = const <String, String>{}, 
    VoidCallback? onSessionExpired,
    bool shouldRefreshAcessToken = true,
  }){
    return apiRequest<T, dynamic>(
      path: path, 
      httpMethods: HttpMethods.get,
      isProtected: isProtected,
      additionalHeaders: additionalHeaders,
      onSessionExpired: onSessionExpired,
      shouldRefreshAccessToken: shouldRefreshAcessToken,
    );
  }

  Future<T> post<T, D>({
    required String path,
    D? data,
    bool isProtected = true,
    Map<String, String> additionalHeaders = const <String, String> {},
    VoidCallback? onSessionExpired,
    bool shouldRefreshAcessToken = true,
  }){
    return apiRequest<T, D>(
      path: path, 
      httpMethods: HttpMethods.post,
      data: data,
      isProtected: isProtected,
      additionalHeaders: additionalHeaders,
      onSessionExpired: onSessionExpired,
      shouldRefreshAccessToken: shouldRefreshAcessToken,
    );
  }

  Future<T> put<T, D>({
    required String path,
    D? data,
    bool isProtected = true,
    Map<String, String> additionalHeaders = const <String, String> {},
    VoidCallback? onSessionExpired,
    bool shouldRefreshAcessToken = true,
  }){
    return apiRequest<T, D>(
      path: path, 
      httpMethods: HttpMethods.put,
      data: data,
      isProtected: isProtected,
      additionalHeaders: additionalHeaders,
      onSessionExpired: onSessionExpired,
      shouldRefreshAccessToken: shouldRefreshAcessToken,
    );
  }

  Future<T> delete<T>({
    required String path,
    bool isProtected = true,
    Map<String, String> additionalHeaders = const <String, String> {},
    VoidCallback? onSessionExpired,
    bool shouldRefreshAcessToken = true,
  }) async {
    return await apiRequest<T, dynamic>(
      path: path, 
      httpMethods: HttpMethods.delete,
      isProtected: isProtected,
      additionalHeaders: additionalHeaders,
      onSessionExpired: onSessionExpired,
      shouldRefreshAccessToken: shouldRefreshAcessToken,
    );
  }

  Future<dynamic> _refreshAccessToken(String host) async {
    if (!_accessTokenCompleter.isCompleted){
      return _accessTokenCompleter.future;
    }

    try{
      _accessTokenCompleter = Completer<String>();
      final String? refreshToken =  await getRefreshToken();
      final Object? body = serializers.serializeWith(
        RefreshToken.serializer, 
        RefreshToken((RefreshTokenBuilder b) => b..refreshToken = refreshToken)
      );

      final http.Response refreshTokenResponse = await http.post(
        Uri(
          path: 'auth/token/refresh/',
          port: port,
          scheme: scheme,
          host: host,
        ),
        body: body,
        headers: <String, String>{
          'Content-Type' : 'application/json',
          'grant_type' : 'refresh_token',
        }
      );

      if (refreshTokenResponse.statusCode != 200){
        _accessTokenCompleter.completeError(Exception('Request Error'));
        return;
      }

      final AccessToken? accessToken = serializers.deserializeWith(
        AccessToken.serializer, 
        refreshTokenResponse.body
      );

      if (accessToken == null){
        _accessTokenCompleter.completeError(Exception('Failed to deserialize access token'));
        return;
      }

      _accessToken = accessToken.access;
      await setAccessToken(_accessToken!);
      _accessTokenCompleter.complete(_accessToken);
      return;
    }catch(e){
      _accessTokenCompleter.completeError(e);
      return;
    }
  }
}
