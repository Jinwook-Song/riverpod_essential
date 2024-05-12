class RouteModel {
  final String name;
  final String path;

  const RouteModel({required this.name, required this.path});
}

class Routes {
  // [미인증]
  static const RouteModel signin = RouteModel(
    name: 'signin',
    path: '/auth-signin',
  );
  static const RouteModel signup = RouteModel(
    name: 'signup',
    path: '/auth-signup',
  );
  static const RouteModel resetPassword = RouteModel(
    name: 'resetPassword',
    path: '/auth-resetPassword',
  );

  // [인증]
  static const RouteModel verifyEmail = RouteModel(
    name: 'verifyEmail',
    path: '/verifyEmail',
  );
  static const RouteModel splash = RouteModel(
    name: 'splash',
    path: '/splash',
  );
  static const RouteModel firebaseError = RouteModel(
    name: 'firebaseError',
    path: '/firebaseError',
  );

  static const RouteModel home = RouteModel(
    name: 'home',
    path: '/home',
  );
  static const RouteModel changePassword = RouteModel(
    name: 'changePassword',
    path: 'changePassword',
  );
}
