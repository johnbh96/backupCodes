enum AppRoutes {
  home,
  welcomeScreen,
  signin,
  phoneAuthenticationForm,
  phoneVerificationForm,
}


extension AppRoutesExtension on AppRoutes {
  String get path {
    switch (this) {
      case AppRoutes.home:
        return '/';
      case AppRoutes.welcomeScreen:
        return 'welcome-screen';
      case AppRoutes.signin:
        return 'signin';
      case AppRoutes.phoneAuthenticationForm:
        return 'phoneAuthForm';
      case AppRoutes.phoneVerificationForm:
        return 'verifyPhoneNumber';
    }
  }

  String get name {
    switch (this) {
      case AppRoutes.home:
        return '/';
      case AppRoutes.welcomeScreen:
        return 'welcome-screen';
      case AppRoutes.signin:
        return 'signin';
      case AppRoutes.phoneAuthenticationForm:
        return 'Phone-Authentication';
      case AppRoutes.phoneVerificationForm:
        return 'verifyPhoneNumber';
    }
  }
}
