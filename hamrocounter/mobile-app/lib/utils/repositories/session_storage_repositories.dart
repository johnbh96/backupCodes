import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../exceptions/exception.dart';
import '../keys/keys.dart';

class SessionStorageRepositories with ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;

  final FlutterSecureStorage secureStorage;

  bool get isLoggedIn => _accessToken != null && _refreshToken != null;

  SessionStorageRepositories(
    this._accessToken,
    this._refreshToken,
    this.secureStorage,
  ) : super();

  Future<void> setCredentials(String accessToken, String refreshToken) async {
    await secureStorage.write(key: Keys.accessTokenKey, value: accessToken);
    await secureStorage.write(key: Keys.refreshTokenKey, value: refreshToken);
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    notifyListeners();
  }

  Future<void> deleteCredentials() async {
    await secureStorage.delete(key: Keys.accessTokenKey);
    await secureStorage.delete(key: Keys.refreshTokenKey);
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  Future<String?> getAccessToken() async {
    return _accessToken ?? await secureStorage.read(key: Keys.accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _refreshToken ?? await secureStorage.read(key: Keys.refreshTokenKey);
  }

  Future<void> setAccessToken(String accessToken) async {
    final bool refreshTokenExists =
        await secureStorage.containsKey(key: Keys.accessTokenKey);

    if (!refreshTokenExists) {
      throw BadStateException(
          'Required refresh token when updating access token',
          'Failed to authenticate');
    }

    await secureStorage.write(key: Keys.accessTokenKey, value: accessToken);
    notifyListeners();
  }

  Future<void> setUserId(String uid) async {
    await secureStorage.write(key: Keys.userIdKey, value: uid);
    notifyListeners();
  }

  Future<bool> getUserId() async {
    final String? userId = await secureStorage.read(key: Keys.userIdKey);
    if (userId == null || userId.isEmpty) {
      return true;
    }
    return false;
  }

}

// ignore: always_specify_types
class SimpleNotifier extends InheritedNotifier {
  const SimpleNotifier(
      {Key? key, required Listenable notifier, required Widget child})
      : super(child: child, key: key, notifier: notifier);
}
