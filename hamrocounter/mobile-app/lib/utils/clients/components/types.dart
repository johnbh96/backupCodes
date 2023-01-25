import 'package:flutter/foundation.dart';
import '../../typedef/types.dart';

typedef CredentialSetter = Future<void> Function(String, String);
typedef CredentialDeleter = AsyncCallback;
typedef AccessTokenGetter = Future<String?> Function();
typedef RefreshTokenGetter = Future<String?> Function();
typedef AccessTokenSetter = StringAsyncCallBack;
