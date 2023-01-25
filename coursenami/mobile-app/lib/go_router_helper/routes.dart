enum AppRoutes {
  home,
  welcomeScreen,
  login
}

extension AppRoutesExtension on AppRoutes {
  String get path {
    switch (this) {
      case AppRoutes.home:
        return '/';
      case AppRoutes.welcomeScreen:
        return 'welcome-screen';
      case AppRoutes.login:
        return 'login';
    }
  }

  String get name {
    switch (this) {
      case AppRoutes.home:
        return 'home';
      case AppRoutes.welcomeScreen:
        return 'welcome-screen';
      case AppRoutes.login:
        return 'login';
    }
  }
}
